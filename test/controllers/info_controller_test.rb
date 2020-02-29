require 'test_helper'

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get info_index_url
    assert_response :success
  end

  test "should get how-to-use" do
    get info_how-to-use_url
    assert_response :success
  end

  test "should get terms-of-service" do
    get info_terms-of-service_url
    assert_response :success
  end

  test "should get privacy-policy" do
    get info_privacy-policy_url
    assert_response :success
  end

  test "should get what-is-varth" do
    get info_what-is-varth_url
    assert_response :success
  end

end
