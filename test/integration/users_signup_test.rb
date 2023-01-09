require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: {user:{ name: 'f',
                               email: "user@invalid",
                               password: "fo1AS@#",
                               password_confirmation: "f1AS@#" }}

    end
    assert_template 'users/new'
    assert_select "form:match('id', ?)", /\Anew_user/ #div#<CSS id for error explanation>
    assert_select "div:match('class', ?)", /\Acontainer/ #div.<CSS class for field with error>
    assert_select "input:match('class', ?)", /\Abtn/
    assert_select "h1", "Sign Up"
    assert_select "label", "Name"
    assert_select "label", "Email"
    assert_select "label", "Password"
    post users_path, params: {user:{ name: 'f',
                                     email: "user@i",
                                     password: "fo1AS@#",
                                     password_confirmation: "f1AS@#" }}
    assert_select "ul:match('id', ?)", /\Aerror_explanation/
    assert_select "li", /\AName/
    assert_select "li", /\AEmail/
    assert_select "li", /\APassword/
    assert_select "li", /\APassword confirmation/
  end
  test "valid signup information with account activation" do
    get sign_up_path
    assert_difference 'User.count', 1  do
      post users_path, params: {user:{ name: 'Example User',
                                      email: "user@example.com",
                                      password: "Pas$w0rd",
                                      password_confirmation: "Pas$w0rd" }}

      #follow_redirect!
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Недопустимый токен активации
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Допустимый токен, неверный адрес электронной почты
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Допустимый токен
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
       assert_select "div:match('class', ?)", /\Aalert alert-success/
    #  assert_select "div", "User was successfully created."
    #  assert_select "div", "Welcome to the Sample App!"
     assert_not flash[:danger]
    assert is_logged_in?
    get root_path
  end
end
