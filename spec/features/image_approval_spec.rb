require "rails_helper"

RSpec.feature "Image approvals", :type => :feature do
  before(:example) do
    @user = create(:user)
    upload_images_as(@user)
  end

  scenario "non-admin tries to approve images", js: true do
    log_in(@user)
    visit user_path(@user)
    click_link("Awaiting Approval (2)")
    expect(page).to_not have_css(".approve-btn")
  end

  scenario "admin approves image", js: true, solr: true do
    @admin = create(:admin)
    log_in(@admin)
    visit user_path(@user)
    click_link("Awaiting Approval (2)")
    click_link("upload-#{Upload.first.id}")
    expect(page).to have_button("approve")
    expect(page).to have_css(".unapproved")
    click_button("approve")
    expect(page).to_not have_css(".unapproved")
    visit user_path(@user)
    expect(page).to have_css(".approved", count: 1)
    Sunspot.commit
    visit root_path
    expect(page).to have_css(".approved", count: 1)
  end

end
