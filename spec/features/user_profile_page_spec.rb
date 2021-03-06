require "rails_helper"

RSpec.feature "User profile page", :type => :feature do
  before do
    @user = create(:user)
    upload_images_as(@user)
  end

  context "Admin is logged in" do
    before do
      @admin = create(:user, admin: true)
      log_in(@admin)
      visit user_path(@user)
    end

    scenario "Admin sees everything", js: true do
      expect(page).to_not have_css(".upload-thumb")
      create(:upload, user: @user, approved: true)
      visit user_path(@user)
      expect(page).to have_link("Uploads (1)")
      expect(page).to have_css(".upload-thumb", count: 1)
      expect(page).to have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to have_link("Edit Profile")
      expect(page).to have_css("#edit-user-avatar")
      expect(page).to have_link("Awaiting Approval (2)")
      expect(page).to have_css(".tags-container", count: 1)
      expect(page).to have_css(".edit-tags", count: 1)
      expect(page).to have_css(".disapprove", count: 1)

      click_link("Awaiting Approval (2)")
      expect(page).to have_css(".upload-thumb", count: 2)
      expect(page).to have_css(".no-tags", count: 2)
      expect(page).to have_css(".tags-container", count: 2)
      expect(page).to have_css(".edit-tags", count: 2)
      expect(page).to have_css(".approve", count: 2)
    end

  end

  context "User is logged in" do

    before do
      log_in(@user)
      visit user_path(@user)
    end

    scenario "User sees everything they should", js: true do
      expect(page).to have_link("Uploads (0)")
      expect(page).to_not have_css(".upload-thumb")
      expect(page).to have_link("Awaiting Approval (2)")
      create(:upload, user: @user, approved: true)
      visit user_path(@user)
      expect(page).to have_link("Uploads (1)")
      expect(page).to have_css(".upload-thumb", count: 1)
      expect(page).to have_link("Favorites (0)")
      expect(page).to have_link("Edit Profile")
      expect(page).to have_css(".upload-btn")
      expect(page).to have_css("#edit-user-avatar")
      expect(page).to have_css(".tags-container", count: 1)
      expect(page).to have_css(".edit-tags", count: 1)
      expect(page).to_not have_css(".disapprove")

      click_link("Awaiting Approval (2)")
      expect(page).to have_css(".upload-thumb", count: 2)
      expect(page).to have_css(".no-tags", count: 2)
      expect(page).to have_css(".tags-container", count: 2)
      expect(page).to have_css(".edit-tags", count: 2)
      expect(page).to_not have_css(".approve")
    end

  end

  context "Other user is logged in" do

    before do
      @other_user = create(:user)
      log_in(@other_user)
      visit user_path(@user)
    end

    scenario "Other user sees only what they should" do
      create(:upload, user: @user, approved: true)

      visit user_path(@user)
      expect(page).to have_css(".upload-thumb", count: 1)
      expect(page).to_not have_link("Awaiting Approval (2)")
      expect(page).to_not have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_css("#edit-user-avatar")
      expect(page).to_not have_css(".tags-container")
      expect(page).to_not have_css(".edit-tags")
      expect(page).to_not have_css(".disapprove")
    end

  end

  context "No user is logged in" do

    before do
      visit user_path(@user)
    end

    scenario "Guest user sees only what they should" do
      create(:upload, user: @user, approved: true)

      visit user_path(@user)
      expect(page).to have_css(".upload-thumb", count: 1)
      expect(page).to_not have_link("Awaiting Approval (2)")
      expect(page).to_not have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_css("#edit-user-avatar")
      expect(page).to_not have_css(".tags-container")
      expect(page).to_not have_css(".edit-tags")
      expect(page).to_not have_css(".disapprove")
    end
  end

end
