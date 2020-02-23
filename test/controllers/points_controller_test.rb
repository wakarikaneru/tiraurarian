require 'test_helper'

class PointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @point = points(:one)
  end

  test "should get index" do
    get points_url
    assert_response :success
  end

  test "should get new" do
    get new_point_url
    assert_response :success
  end

  test "should create point" do
    assert_difference('Point.count') do
      post points_url, params: { point: { point: @point.point, user_id: @point.user_id } }
    end

    assert_redirected_to point_url(Point.last)
  end

  test "should show point" do
    get point_url(@point)
    assert_response :success
  end

  test "should get edit" do
    get edit_point_url(@point)
    assert_response :success
  end

  test "should update point" do
    patch point_url(@point), params: { point: { point: @point.point, user_id: @point.user_id } }
    assert_redirected_to point_url(@point)
  end

  test "should destroy point" do
    assert_difference('Point.count', -1) do
      delete point_url(@point)
    end

    assert_redirected_to points_url
  end
end
