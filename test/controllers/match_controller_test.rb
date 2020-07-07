require 'test_helper'

class MatchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get match_index_url
    assert_response :success
  end

  test "should get search" do
    get match_search_url
    assert_response :success
  end

end
