require 'test_helper'

class NoticesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notice = notices(:one)
  end

  test "should get index" do
    get notices_url
    assert_response :success
  end

  test "should get new" do
    get new_notice_url
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post notices_url, params: { notice: { content: @notice.content, create_datetime: @notice.create_datetime, read_flag: @notice.read_flag, sender: @notice.sender, title: @notice.title, user_id: @notice.user_id } }
    end

    assert_redirected_to notice_url(Notice.last)
  end

  test "should show notice" do
    get notice_url(@notice)
    assert_response :success
  end

  test "should get edit" do
    get edit_notice_url(@notice)
    assert_response :success
  end

  test "should update notice" do
    patch notice_url(@notice), params: { notice: { content: @notice.content, create_datetime: @notice.create_datetime, read_flag: @notice.read_flag, sender: @notice.sender, title: @notice.title, user_id: @notice.user_id } }
    assert_redirected_to notice_url(@notice)
  end

  test "should destroy notice" do
    assert_difference('Notice.count', -1) do
      delete notice_url(@notice)
    end

    assert_redirected_to notices_url
  end
end
