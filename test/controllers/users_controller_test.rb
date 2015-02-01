require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @base_title = "Clipped"
    @user = users(:michael)
    @other_user = users(:archer)
  end


  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Sign up")
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

  test "should redirect edit when logged in as wrong user" do
    log_in_as @other_user
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @other_user
    get :update, id: @user, user: {email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: 1 }
    assert_not @other_user.reload.admin?
  end

end
