require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    get :update, id: @user, user: {email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
