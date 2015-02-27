require "rails_helper"

RSpec.feature "User profile page", :type => :feature do
  before(:example) do
    @user = create(:user)
    upload_images_as(@user)
  end 

  scenario "User views own profile page" do
    log_in(@user)

    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 2)
  end

  scenario "Admin user views other user's profile page" do
    @admin = create(:user, admin: true)
    log_in(@admin)

    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 2)
  end

  scenario "Other logged in user views user's profile page (no approved images)" do
    @other_user = create(:user)
    log_in(@other_user)

    visit user_path(@user)
    expect(page).to_not have_css(".upload-thumb")
    expect(page).to_not have_css(".upload-btn")
  end

  scenario "Other logged in user views user's profile page (approved images)" do
    @other_user = create(:user)
    log_in(@other_user)

    create(:upload, user: @user, approved: true)

    visit user_path(@user)
    expect(page).to have_css(".upload-thumb", count: 1)
  end
end