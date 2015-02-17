require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject(:upload) { create(:upload) }

  it { is_expected.to be_valid }

  it "has associated user" do
    upload.user_id = nil
    expect(upload).to be_invalid
  end

  it "has associated image" do
    upload.direct_upload_url = nil
    expect(upload).to be_invalid
  end

  it "is ordered by newest first" do
    upload.created_at = 3.seconds.ago
    newer_upload = create(:upload, created_at: Time.now)
    expect(Upload.all).to eq [newer_upload, upload]
  end
end
