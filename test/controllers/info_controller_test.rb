require 'test_helper'

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get info_index_url
    assert_response :success
  end

  test "should get howtouse" do
    get info_howtouse_url
    assert_response :success
  end

  test "should get termsofservice" do
    get info_termsofservice_url
    assert_response :success
  end

  test "should get privacypolicy" do
    get info_privacypolicy_url
    assert_response :success
  end

  test "should get whatisvarth" do
    get info_whatisvarth_url
    assert_response :success
  end

end
