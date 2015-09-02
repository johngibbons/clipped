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
      create(:upload, user: @user, approved: true)
      visit user_path(@user)
      expect(page).to have_link("Uploads (1)")
      expect(page).to have_css(".upload-thumb", count: 1)
      expect(page).to have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to have_link("Edit Profile")
      expect(page).to have_css("#edit-user-avatar")
      expect(page).to have_link("Awaiting Approval (2)")

      click_link("Awaiting Approval (2)")
      expect(page).to have_css(".upload-thumb", count: 2)
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
      expect(page).to_not have_link("Awaiting Approval (2)")
      expect(page).to_not have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_css("#edit-user-avatar")
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
      expect(page).to_not have_link("Awaiting Approval (2)")
      expect(page).to_not have_link("Favorites (0)")
      expect(page).to_not have_css(".upload-btn")
      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_css("#edit-user-avatar")
    end
  end

end
