require './app/services/process_uploads'
require 'rails_helper'

describe ProcessUploads do
  before(:example) do
    @upload = build(:upload)
  end

  describe "#queue_processing" do
    it "processes images" do
      expect(@upload.processed?).to eq(false)
      ProcessUploads.call(upload: @upload)
      expect(@upload.processed?).to eq(true)
    end
  end
end