require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get locations_index_url
    assert_response :success
  end

  test "should get new" do
    get locations_new_url
    assert_response :success
  end

  test "should get show" do
    get locations_show_url
    assert_response :success
  end
end
