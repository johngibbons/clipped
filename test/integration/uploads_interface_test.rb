require 'test_helper'

class UploadsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "upload interface" do
    log_in_as(@user)
    get root_path
    assert_select '.most-popular-uploads'
    get user_path(@other_user)
    #don't show upload button for other users
    assert_select "a[href=?]", '/uploads/new', count: 0
    get user_path(@user)
    #show upload button for current user
    assert_select "a[href=?]", '/uploads/new', count: 1
    get new_upload_path
    #invalid submission
    assert_no_difference 'Upload.count' do
      post uploads_path, upload: { image_file_name: "" }
    end
    # assert_select '#error_explanation'
    # assert_template 'uploads/new'
    #valid submission
    upload_tags = "some, sample, tags"
    assert_difference 'Upload.count', 1 do
      post uploads_path, upload: { image: "image.png", tags: upload_tags, user_id: 1 }
    end
    # assert_redirected_to user_url(@user)
    # follow_redirect!
    # assert_match upload_tags, response.body
    # #Delete a post.
    # assert_select 'a', text: 'delete'
    # first_upload = @user.uploads.paginate(page: 1).first
    # assert_difference 'Upload.count', -1 do
    #   delete upload_path(first_upload)
    # end
    # #visit a different user.
    # get user_path(@other_user)
    # assert_select 'a', text: 'delete', count: 0
  end
end
