require './app/services/process_uploads'
require 'rails_helper'

describe ProcessUploads do
  before(:example) do
    @upload = build(:upload)
    @service = ProcessUploads.new(@upload)
  end

  describe "#queue_processing" do
    it "processes images" do
      @service.queue_processing
      expect(@upload.processed?).to eq(true)
    end
  end
end