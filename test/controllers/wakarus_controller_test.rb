require 'test_helper'

class WakarusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wakaru = wakarus(:one)
  end

  test "should get index" do
    get wakarus_url
    assert_response :success
  end

  test "should get new" do
    get new_wakaru_url
    assert_response :success
  end

  test "should create wakaru" do
    assert_difference('Wakaru.count') do
      post wakarus_url, params: { wakaru: {  } }
    end

    assert_redirected_to wakaru_url(Wakaru.last)
  end

  test "should show wakaru" do
    get wakaru_url(@wakaru)
    assert_response :success
  end

  test "should get edit" do
    get edit_wakaru_url(@wakaru)
    assert_response :success
  end

  test "should update wakaru" do
    patch wakaru_url(@wakaru), params: { wakaru: {  } }
    assert_redirected_to wakaru_url(@wakaru)
  end

  test "should destroy wakaru" do
    assert_difference('Wakaru.count', -1) do
      delete wakaru_url(@wakaru)
    end

    assert_redirected_to wakarus_url
  end
end
