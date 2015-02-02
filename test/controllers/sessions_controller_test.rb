require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:identity]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new user" do
    assert_difference('User.count') do
      get :create, :provider => "identity"
    end
    user = User.last
    assert_equal session[:user_id], user.id, "User is logged into session"
    assert_redirected_to user_path(session[:user_id])
  end

  test "should destroy authentication" do
    #log in
    get :create, :provider => "identity"

    user = User.last
    assert_equal session[:user_id], user.id, "user is logged into session"

    #log out
    get :destroy
    assert_equal session[:user_id], nil, "user is logged out of session"
  end
end
