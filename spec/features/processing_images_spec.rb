require "rails_helper"

RSpec.feature "Image processing", :type => :feature do
  before(:example) do
    @user = create(:user)
    upload_images_as(@user)
    log_in(@user)
  end 

  scenario "shows original file until image has been processed" do
    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 2)
    expect(page).to have_image("thumb")
  end
end