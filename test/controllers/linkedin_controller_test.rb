require 'test_helper'

class LinkedinControllerTest < ActionController::TestCase
  test "should get people" do
    get :people
    assert_response :success
  end

  test "should get companies" do
    get :companies
    assert_response :success
  end

end
