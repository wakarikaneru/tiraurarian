require 'test_helper'

class TiraurarianControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tiraurarian_index_url
    assert_response :success
  end

end
