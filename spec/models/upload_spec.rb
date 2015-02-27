require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject(:upload) { build(:upload) }

  it { is_expected.to be_valid }

  it "has associated user" do
    upload.user_id = nil
    expect(upload).to be_invalid
  end

  it "has associated image" do
    upload.image = nil
    expect(upload).to be_invalid
  end

  it "is ordered by newest first" do
    upload.created_at = 3.seconds.ago
    newer_upload = create(:upload, created_at: Time.now)
    expect(Upload.all.first).to eq newer_upload
    upload.created_at = Time.now.advance(hours: 1)
    upload.save
    expect(Upload.all.first).to eq upload
  end

  it "is rejects invalid file type" do
    invalid_files = %w[ something.xml anything.mp4 sample.doc
                        something.rvt something.html anything.css ]
    invalid_files.each do |invalid_file|
      upload.image_file_name = invalid_file
      expect(upload).to be_invalid
    end
  end

  it "accepts valid file type" do
    valid_files = %w[ something.jpg anything.jpeg sample.JPG
                      something.png anything.Png ]
    valid_files.each do |valid_file|
      upload.image_file_name = valid_file
      expect(upload).to be_valid
    end
  end
end
