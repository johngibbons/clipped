require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @base_title = "Clipped"
  end


  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Sign up")
  end

end
