require './app/services/process_uploads'
require 'rails_helper'

describe ProcessUploads do
  before(:example) do
    @upload = build(:upload, direct_upload_url: "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads%2F%7Btimestamp%7D-%7Bunique_id%7D-f5a2a3ba653b28f441fbdb96c7a06473%2Fjohn.jpg")
    @service = ProcessUploads.new(@upload)
  end

  describe "#queue_processing" do
    it "processes images" do
      @service.queue_processing
      expect(@upload.processed?).to eq(true)
    end
  end
end