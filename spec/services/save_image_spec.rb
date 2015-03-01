require './app/services/save_image'
require 'rails_helper'

describe SaveImage do
  before(:example) do
    @upload = build(:upload, image: nil)
    SaveImage.call(upload: @upload)
  end

  describe "#set_upload_attributes" do
    it "sets proper upload attributes" do
      expect(@upload.image_file_size).to_not be_nil
      expect(@upload.image_content_type).to eq("image/jpeg")
      expect(@upload.image_updated_at).to be_a(Time)
      expect(@upload).to be_valid
    end
  end

end