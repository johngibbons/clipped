require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @base_title = "Clipped"
    @upload_first = uploads(:orange)
    @upload_second = uploads(:sitting_woman)
    @upload_third = uploads(:walking_man)
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", full_title()
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", full_title("Help")
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", full_title("About")
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", full_title("Contact")
  end

  test "newest posts should sort by created_at" do
    get :home
    # assert_equal @most_recent.first, @upload_first
  end

end
