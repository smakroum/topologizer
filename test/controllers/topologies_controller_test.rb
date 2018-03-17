require 'test_helper'

class TopologiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get topologies_index_url
    assert_response :success
  end

  test "should get show" do
    get topologies_show_url
    assert_response :success
  end

end
