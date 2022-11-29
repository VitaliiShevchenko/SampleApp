require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_row = "Ruby on Rails Tutorial Sample App"
  end
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Home | 5" + @base_row
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | 5#{@base_row}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | 5Ruby on Rails Tutorial Sample App"
  end
end
