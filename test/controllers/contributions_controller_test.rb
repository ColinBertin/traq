require "test_helper"

class ContributionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contributions_index_url
    assert_response :success
  end

  test "should get new" do
    get contributions_new_url
    assert_response :success
  end

  test "should get edit" do
    get contributions_edit_url
    assert_response :success
  end
end
