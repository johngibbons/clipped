require './app/services/create_upload_from_url'
require 'rails_helper'

describe CreateUploadFromURL do
  before(:example) do
    @upload = build(:upload, image: nil, direct_upload_url: "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/9a51da779b300880800edc0666e51401/amanda.jpg")
    @service = CreateUploadFromURL.new(@upload)
  end

  it "has valid upload" do
    expect(@upload).to be_valid
  end

  describe "#set_upload_attributes" do
    it "sets proper upload attributes" do
      @service.set_upload_attributes
      expect(@upload.image_file_name).to eq("amanda.jpg")
      expect(@upload.image_file_size).to_not be_nil
      expect(@upload.image_content_type).to eq("image/jpeg")
      expect(@upload.image_updated_at).to be_a(Time)
    end
  end

end