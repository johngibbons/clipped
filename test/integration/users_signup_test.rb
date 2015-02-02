require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "",
                               password: "tooshort",
                               password_confirmation: "notsame" }
    end
    assert_template "users/new"
    assert_select 'div.flash-error'
    assert_select 'li.individual-error'
  end

    test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: "sample@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    # assert_template "users/show"
    # assert_not flash.nil?
    # assert is_logged_in?
  end
end
