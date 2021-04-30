require "test_helper"

class TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get test1" do
    get tests_test1_url
    assert_response :success
  end
end
