require 'test_helper'

class BadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bad = bads(:one)
  end

  test "should get index" do
    get bads_url
    assert_response :success
  end

  test "should get new" do
    get new_bad_url
    assert_response :success
  end

  test "should create bad" do
    assert_difference('Bad.count') do
      post bads_url, params: { bad: { create_datetime: @bad.create_datetime, tweet_id: @bad.tweet_id, user_id: @bad.user_id } }
    end

    assert_redirected_to bad_url(Bad.last)
  end

  test "should show bad" do
    get bad_url(@bad)
    assert_response :success
  end

  test "should get edit" do
    get edit_bad_url(@bad)
    assert_response :success
  end

  test "should update bad" do
    patch bad_url(@bad), params: { bad: { create_datetime: @bad.create_datetime, tweet_id: @bad.tweet_id, user_id: @bad.user_id } }
    assert_redirected_to bad_url(@bad)
  end

  test "should destroy bad" do
    assert_difference('Bad.count', -1) do
      delete bad_url(@bad)
    end

    assert_redirected_to bads_url
  end
end
