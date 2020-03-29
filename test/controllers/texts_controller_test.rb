require 'test_helper'

class TextsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @text = texts(:one)
  end

  test "should get index" do
    get texts_url
    assert_response :success
  end

  test "should get new" do
    get new_text_url
    assert_response :success
  end

  test "should create text" do
    assert_difference('Text.count') do
      post texts_url, params: { text: { content: @text.content, create_datetime: @text.create_datetime, tweet_id: @text.tweet_id, user_id: @text.user_id } }
    end

    assert_redirected_to text_url(Text.last)
  end

  test "should show text" do
    get text_url(@text)
    assert_response :success
  end

  test "should get edit" do
    get edit_text_url(@text)
    assert_response :success
  end

  test "should update text" do
    patch text_url(@text), params: { text: { content: @text.content, create_datetime: @text.create_datetime, tweet_id: @text.tweet_id, user_id: @text.user_id } }
    assert_redirected_to text_url(@text)
  end

  test "should destroy text" do
    assert_difference('Text.count', -1) do
      delete text_url(@text)
    end

    assert_redirected_to texts_url
  end
end
