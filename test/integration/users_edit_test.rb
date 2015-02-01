require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: { email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template "users/edit"
  end

  test "successful edit with friendly forwarding only on first login" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    email = "sample@example.com"
    patch user_path(@user), user: { email: "sample@example.com",
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.email, email
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    log_in_as(@user)
    assert_redirected_to @user
  end
end
