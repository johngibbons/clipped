require 'rails_helper'
require './app/services/save_image'

describe SaveImage do
  before do
    @upload = build(:upload)
  end

  describe "#set_upload_attributes" do
    it "sets proper upload attributes" do
      VCR.use_cassette("save_image", match_requests_on: [:host]) do
        @upload.image = nil
        expect(@upload.image_file_size).to be_nil
        expect(@upload).to_not be_valid
        SaveImage.call(upload: @upload)
        expect(@upload.image_file_size).to_not be_nil
        expect(@upload.image_content_type).to eq("image/png,")
        expect(@upload.image_updated_at).to be_a(Time)
        expect(@upload).to be_valid
      end
    end
  end

end
