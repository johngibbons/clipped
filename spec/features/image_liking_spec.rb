require "rails_helper"

RSpec.feature "Image liking", :type => :feature do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }
  subject(:upload) { create(:upload, approved: true) }

  context "user is logged in" do

    before(:example) do
      log_in(user)
    end 

    scenario "user likes an image" do
      visit upload_path(upload)
      expect(page).to have_content("Views")
      expect do
        click_button "Like"
      end.to change{upload.reload.likes_count}.by(1)
    end

    scenario "user unlikes an image" do
      user.like(upload)
      visit upload_path(upload)
      expect do
        click_button "Unlike"
      end.to change{upload.reload.likes_count}.by(-1)
    end
  end
end