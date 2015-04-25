require "rails_helper"

RSpec.feature "Image favoriting", :type => :feature do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }
  subject(:upload) { create(:upload, approved: true) }

  context "user is logged in" do

    before(:example) do
      log_in(user)
    end 

    scenario "user favorites an image" do
      visit upload_path(upload)
      expect(page).to have_content("Views")
      expect do
        click_button "favorite"
      end.to change{upload.reload.favorites_count}.by(1)
    end

    scenario "user unfavorites an image" do
      user.favorite(upload)
      visit upload_path(upload)
      expect do
        click_button "unfavorite"
      end.to change{upload.reload.favorites_count}.by(-1)
    end
  end

  context "user is not logged in" do
    scenario "user tries to favorite an image" do
      visit upload_path(upload)
      expect(page).to have_content("Views")
      expect(page).to_not have_button("Like")
      expect(page).to_not have_button("Unfavorite")
    end
  end
end