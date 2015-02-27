require "rails_helper"

RSpec.feature "Image processing", :type => :feature do
  before(:example) do
    @user = create(:user)
    @upload = create(:upload, user: @user, processed: false)
    log_in(@user)
  end 

  scenario "shows original file until image has been processed" do
    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 1)
    expect(page).to_not have_image "thumb"
    expect(@upload.processed?).to eq(false)
  end
end