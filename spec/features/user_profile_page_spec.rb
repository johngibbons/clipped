require "rails_helper"

RSpec.feature "User profile page", :type => :feature do
  before(:example) do
    @user = create(:user)
    upload_images_as(@user)
  end 

  scenario "User views own profile page", js: true do
    log_in(@user)

    visit user_path(@user)
    expect(page).to have_link("Uploads (0)")
    expect(page).to_not have_css(".upload-thumb")
    expect(page).to have_link("Awaiting Approval (2)")

    create(:upload, user: @user, approved: true)

    visit user_path(@user)
    expect(page).to have_link("Uploads (1)")

    click_link("Awaiting Approval (2)")
    expect(page).to have_css(".upload-thumb", count: 2)
    expect(page).to have_link("Favorites (0)")

  end

  scenario "Admin user views other user's profile page", js: true do
    @admin = create(:user, admin: true)
    log_in(@admin)

    visit user_path(@user)
    expect(page).to have_link("Uploads (0)")
    expect(page).to_not have_css(".upload-thumb")
    expect(page).to have_link("Awaiting Approval (2)")

    click_link("Awaiting Approval (2)")
    expect(page).to have_css(".upload-thumb", count: 2)
  end

  scenario "Other logged in user views user's profile page (no approved images)" do
    @other_user = create(:user)
    log_in(@other_user)

    visit user_path(@user)
    expect(page).to_not have_css(".upload-btn")
    expect(page).to_not have_link("Awaiting Approval (2)")
    expect(page).to_not have_link("Favorites (0)")
  end

  scenario "Other logged in user views user's profile page (approved images)" do
    @other_user = create(:user)
    log_in(@other_user)

    create(:upload, user: @user, approved: true)

    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 1)
    expect(page).to_not have_link("Awaiting Approval (1)")
  end

end
