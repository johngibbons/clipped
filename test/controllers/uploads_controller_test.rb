require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  
  def setup
    @upload = uploads(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Upload.count' do
      post :create, upload: { image_file_name: "image.jpg" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Upload.count' do
      delete :destroy, id: @upload
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong upload" do
    current = users(:michael)
    log_in_as(current)
    not_current_upload = uploads(:sitting_woman)
    assert_no_difference "Upload.count" do
      delete :destroy, id: not_current_upload
    end
    assert_redirected_to user_path(current)
  end
end
