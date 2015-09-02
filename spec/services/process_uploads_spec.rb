require 'rails_helper'
require './app/services/process_uploads'

describe ProcessUploads do
  before do
    @upload = build(:upload)
  end

  describe "#queue_processing" do
    it "processes images" do
      expect(@upload.processed?).to eq(false)
      VCR.use_cassette('process_upload', match_requests_on: [:host]) do
        ProcessUploads.call(upload: @upload)
      end
      expect(@upload.processed?).to eq(true)
    end
  end
end
