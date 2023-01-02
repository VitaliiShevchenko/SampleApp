require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vitalii)
    @other_user = users(:archer)
    @admin  = users(:vitalii)
  end
  test "should get new" do
    get sign_up_path
    assert_response :success
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
  end
  test "should redirect edit when not logged in" do
    get edit_user_path id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
    follow_redirect!
    assert_select "div", "Please log in."
  end
  test "should redirect update when not logged in" do
    patch user_path id: @user, params:{user: { name: @user.name, email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
    follow_redirect!
    assert_select "div", "Please log in."
  end
  test "should redirect edit when logged in as wrong user" do
    log_in_as( @user )
    get edit_user_path id: @other_user
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "div", "You have the limit permissions for this operation."
  end
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path id: @user, params:{user: { name: @user.name, email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "div", "You have the limit permissions for this operation."
  end
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path id: @user
    end
    assert_redirected_to login_url
  end
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path id: @user
    end
    assert_redirected_to root_url
  end
  test "should be friendly redirect after login" do
  get users_path 80
  assert_equal users_url(80), session[:forwarding_url]
  assert_redirected_to login_path
  log_in_as(@user)
  assert_redirected_to users_path 80
  log_in_as(@user)
  assert_redirected_to @user
  #    assert_equal session[:forwarding_url], nil
  end
end
