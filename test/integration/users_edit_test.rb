require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vitalii)
  end
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params:{user: { name: '',
                                    email: 'foo@invalid',
                                    password:'foo',
                                    password_confirmation: 'bar' }}
    assert_template 'users/edit'
  end
  test "successful nothing update" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = @user.name
    email = @user.email
    patch user_path(@user), params: {user:{name: name,
                                          email: email,
                                          password:'',
                                          password_confirmation: '' }}
    assert flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
  test "successful update only name" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = @user.name+"Vitalii"
    email = @user.email
    patch user_path(@user), params: {user:{name: name,
                                           email: email,
                                           password:'',
                                           password_confirmation: '' }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params:{user: { name: name,
                                    email: email,
                                    password:
                                      "Pas$w0rd",
                                    password_confirmation: "Pas$w0rd" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    end
end
