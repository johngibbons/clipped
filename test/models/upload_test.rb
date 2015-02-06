require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @upload = @user.uploads.build(image_file_name: "some_image.jpg", user_id: @user.id)
  end

  test "should be valid" do
    assert @upload.valid?
  end

  test "user id should be present" do
    @upload.user_id = nil
    assert_not @upload.valid?
  end

  test "image should be present" do
    @upload.image = nil
    assert_not @upload.valid?
  end

  test "order should be most recent first" do
    assert_equal Upload.first, uploads(:most_recent)
  end

  # test "image should not be invalid file types" do
  #   invalid_files = %w[something.xml anything.mp4 sample.doc
  #         something.rvt something.html anything.css]
  #   invalid_files.each do |invalid_file|
  #     @upload.image = invalid_file
  #     assert_not @upload.valid?
  #   end
  # end

  # test "image should be valid image file types" do
  #   valid_files = %w[something.jpg anything.jpeg sample.JPG
  #         something.png anything.Png something.gif anything.GIF]
  #   valid_files.each do |valid_file|
  #     @upload.image = valid_file
  #     assert @upload.valid?
  #   end
  # end
end
