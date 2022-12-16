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
  end
end
