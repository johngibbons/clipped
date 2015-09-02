require "rails_helper"

RSpec.feature "Image approvals", :type => :feature do
  before do
    @user = create(:user)
    upload_to_s3_as(@user)
  end

  scenario "non-admin tries to approve images" do
    visit upload_path(Upload.first.id)
    expect(page).to_not have_button("approve")
  end

  scenario "admin approves image", js: true do
    @admin = create(:admin)
    log_in(@admin)
    visit upload_path(Upload.first.id)
    expect(page).to have_button("approve")
    expect(page).to have_css(".unapproved")
    click_button("approve")
    expect(page).to_not have_css(".unapproved")
    visit user_path(@user)
    expect(page).to have_css(".approved", count: 1)
  end

end
