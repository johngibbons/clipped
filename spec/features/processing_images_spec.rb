require "rails_helper"

RSpec.feature "Image processing", :type => :feature do
  before(:example) do
    @user = create(:user)
    @upload = create(:upload, user: @user, processed: false)
    log_in(@user)
  end 

  scenario "shows original file until image has been processed", js: true do
    visit user_path(@user)
    expect(page).to have_link("Awaiting Approval (1)")
    click_link("Awaiting Approval (1)")
    expect(page).to have_css(".upload-thumb", count: 1)
    expect(page).to_not have_image "thumb"
    expect(@upload.processed?).to eq(false)
  end

  scenario "shows processed image after processing", js: true do
    @upload.processed = true
    @upload.save
    visit user_path(@user)
    expect(page).to have_link("Awaiting Approval (1)")
    click_link("Awaiting Approval (1)")
    expect(page).to have_image "thumb"
    expect(@upload.processed?).to eq(true)
  end
end
