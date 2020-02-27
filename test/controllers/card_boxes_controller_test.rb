require 'test_helper'

class CardBoxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_box = card_boxes(:one)
  end

  test "should get index" do
    get card_boxes_url
    assert_response :success
  end

  test "should get new" do
    get new_card_box_url
    assert_response :success
  end

  test "should create card_box" do
    assert_difference('CardBox.count') do
      post card_boxes_url, params: { card_box: { create_datetime: @card_box.create_datetime, size: @card_box.size, user_id: @card_box.user_id } }
    end

    assert_redirected_to card_box_url(CardBox.last)
  end

  test "should show card_box" do
    get card_box_url(@card_box)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_box_url(@card_box)
    assert_response :success
  end

  test "should update card_box" do
    patch card_box_url(@card_box), params: { card_box: { create_datetime: @card_box.create_datetime, size: @card_box.size, user_id: @card_box.user_id } }
    assert_redirected_to card_box_url(@card_box)
  end

  test "should destroy card_box" do
    assert_difference('CardBox.count', -1) do
      delete card_box_url(@card_box)
    end

    assert_redirected_to card_boxes_url
  end
end
