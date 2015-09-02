require "rails_helper"

RSpec.feature "Image processing", :type => :feature do
  before do
    @user = create(:user)
    @upload = create(:uploaded_upload, user: @user, processed: false, approved: true)
    log_in(@user)
  end

  scenario "shows original file until image has been processed", js: true do
    @upload.save!
    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 1)
    expect(page).to_not have_image "thumb"
    expect(@upload.processed?).to eq(false)
  end

  scenario "shows processed image after processing", js: true do
    @upload.processed = true
    @upload.save!
    visit user_path(@user)
    expect(page).to have_image "thumb"
    expect(@upload.processed?).to eq(true)
  end
end
