require 'test_helper'

class N2vControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
