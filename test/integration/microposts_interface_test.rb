require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vitalii)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Недопустимая информация в форме.
    assert_no_difference 'Micropost.count' do
      post microposts_path micropost: { content: "" }
    end
    assert_select 'ul#error_explanation'
    # Допустимая информация в форме.
    content = "This micropost really ties the room together"
    picture_png = fixture_file_upload('rails.png', 'image/png')
    #picture = /#{picture} @content_type='#{picture.content_type}', @original_filename='#{picture.original_filename}', @tempfile=#{picture.tempfile}/
    assert_difference 'Micropost.count', 1 do
      post microposts_path micropost: { content: content, picture: picture_png }
    end
    micropost = assigns(:micropost)
    #assert micropost.picture?    # DONT WORK
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Удаление сообщения.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Переход в профиль другого пользователя.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  #тест счетчика микросообщений в боковой панели
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # У пользователя нет сообщений
    other_user = users(:lana)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "A micropost", response.body
    assert_match "1 micropost", response.body
  end
end
