require 'test_helper'

class MutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mute = mutes(:one)
  end

  test "should get index" do
    get mutes_url
    assert_response :success
  end

  test "should get new" do
    get new_mute_url
    assert_response :success
  end

  test "should create mute" do
    assert_difference('Mute.count') do
      post mutes_url, params: { mute: { create_datetime: @mute.create_datetime, target_id: @mute.target_id, user_id: @mute.user_id } }
    end

    assert_redirected_to mute_url(Mute.last)
  end

  test "should show mute" do
    get mute_url(@mute)
    assert_response :success
  end

  test "should get edit" do
    get edit_mute_url(@mute)
    assert_response :success
  end

  test "should update mute" do
    patch mute_url(@mute), params: { mute: { create_datetime: @mute.create_datetime, target_id: @mute.target_id, user_id: @mute.user_id } }
    assert_redirected_to mute_url(@mute)
  end

  test "should destroy mute" do
    assert_difference('Mute.count', -1) do
      delete mute_url(@mute)
    end

    assert_redirected_to mutes_url
  end
end
