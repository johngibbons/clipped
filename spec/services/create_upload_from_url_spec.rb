require './app/services/create_upload_from_url'
require 'rails_helper'

describe CreateUploadFromURL do
  before(:example) do
    @upload = build(:upload, image: nil)
    @service = CreateUploadFromURL.new(@upload)
  end

  describe "#set_upload_attributes" do
    it "sets proper upload attributes" do
      @service.set_upload_attributes
      expect(@upload.image_file_size).to_not be_nil
      expect(@upload.image_content_type).to eq("image/jpeg,")
      expect(@upload.image_updated_at).to be_a(Time)
      expect(@upload).to be_valid
    end
  end

end