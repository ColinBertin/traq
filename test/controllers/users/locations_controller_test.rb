require "test_helper"

class Users::LocationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_locations_index_url
    assert_response :success
  end
end
