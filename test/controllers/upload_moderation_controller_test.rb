require 'test_helper'

class UploadModerationControllerTest < ActionController::TestCase

  def setup
    @unapproved = uploads(:orange)
    @approved   = uploads(:walking_man)
    @admin      = users(:michael)
    @nonadmin   = users(:archer)
  end

  test "should approve unapproved upload" do
    log_in_as(@admin)
    assert_not @unapproved.approved?
    patch :update, id: @unapproved, upload: { approved: true }
    assert @unapproved.reload.approved?
  end

  test "should disapprove approved upload" do
    log_in_as(@admin)
    assert @approved.approved?
    patch :update, id: @approved, upload: { approved: false }
    assert_not @approved.reload.approved?  
  end

  test "should redirect update when not logged in" do
    patch :update, id: @unapproved, upload: { approved: true }
    assert_redirected_to login_url
  end

end
