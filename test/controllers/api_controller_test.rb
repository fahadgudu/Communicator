require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get auth" do
    get :auth
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
