require './app/services/process_uploads'
require 'rails_helper'

describe ProcessUploads do
  before(:example) do
    @upload = build(:upload, :direct_upload_url => "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/images/53/original/mountains2.jpg")
    @service = ProcessUploads.new(@upload)
  end

  describe "#queue_processing" do
    it "processes images" do
      @service.queue_processing
      expect(@upload.processed?).to eq(true)
    end
  end
end