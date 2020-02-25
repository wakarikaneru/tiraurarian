require 'test_helper'

class ControlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @control = controls(:one)
  end

  test "should get index" do
    get controls_url
    assert_response :success
  end

  test "should get new" do
    get new_control_url
    assert_response :success
  end

  test "should create control" do
    assert_difference('Control.count') do
      post controls_url, params: { control: { key: @control.key, value: @control.value } }
    end

    assert_redirected_to control_url(Control.last)
  end

  test "should show control" do
    get control_url(@control)
    assert_response :success
  end

  test "should get edit" do
    get edit_control_url(@control)
    assert_response :success
  end

  test "should update control" do
    patch control_url(@control), params: { control: { key: @control.key, value: @control.value } }
    assert_redirected_to control_url(@control)
  end

  test "should destroy control" do
    assert_difference('Control.count', -1) do
      delete control_url(@control)
    end

    assert_redirected_to controls_url
  end
end
