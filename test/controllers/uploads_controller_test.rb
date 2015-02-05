require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  
  def setup
    @upload = uploads(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Upload.count' do
      post :create, upload: { image: "image.jpg" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Upload.count' do
      delete :destroy, id: @upload
    end
    assert_redirected_to login_url
  end
end
