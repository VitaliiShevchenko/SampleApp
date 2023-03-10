require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:vitalii)
  end
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Неверный адрес электронной почты
    post password_resets_path password_reset:{email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Верный адрес электронной почты
    post password_resets_path password_reset:{email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_equal flash["success_notice"], "Email sent with password reset instructions"
    assert_redirected_to root_url

    # Форма сброса пароля (expressions)
    user = assigns(:user)

    # Неверный адрес электронной почты
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # Неактивированная учетная запись
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # Верный адрес электронной почты, неверный токен
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Верный адрес электронной почты, верный токен
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Недопустимый пароль и подтверждение
    patch password_reset_path(user.reset_token,
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" })
    assert_select 'ul#error_explanation'

    # Пустой пароль
    patch password_reset_path(user.reset_token,
          email: user.email,
          user: { password:                   " ",
                  password_confirmation: "foobar" })
    assert_not flash.empty?
    assert_template 'password_resets/edit'
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path password_reset: { email: @user.email }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token,
          email: @user.email,
          user: { password:
                    "foobar",
                  password_confirmation: "foobar" })
    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired./i, response.body
  end

  test "output activated users" do
    get sign_up_path
    new_user = {user:{name:" @new_user",
                     email: "new@user.COM",
                     password: "Pas$w0rd",
                     password_confirmation: "Pas$w0rd"}}
    assert_difference 'User.count', 1 do
    post users_path params: new_user
    @new_user  = assigns(:user)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match /Please check your email to activate your account./i, response.body


  end
end
