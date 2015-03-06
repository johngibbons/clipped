require "rails_helper"

RSpec.feature "Image tagging", :type => :feature do

  subject(:user) { create(:user) }
  subject(:upload) { create(:upload, user: user, approved: true) }

  before(:example) do
    log_in(user)
  end 

  scenario "upload owner updates upload tags", :js => true do
   visit upload_path(upload)
   expect(page).to have_content "Edit Tags"
   page.find("#edit-tags-link").click
   expect(page).to have_field "upload_tag_list"
   fill_in "upload_tag_list", with: "sample tag, another, a third"
   click_button "Update"
   expect(page).to have_selector(".tag", count: 3)
   expect(page).to have_content "sample tag"
   expect(page).to_not have_content("Update")
  end

  scenario "admin updates upload tags", :js => true do
    admin = create(:user, admin: true)
    log_in(admin)
    visit upload_path(upload)
    expect(page).to have_content "Edit Tags"
    page.find("#edit-tags-link").click
    expect(page).to have_field "upload_tag_list"
    fill_in "upload_tag_list", with: "sample tag, another, a third"
    click_button "Update"
    expect(page).to have_selector(".tag", count: 3)
    expect(page).to have_content "sample tag"
    expect(page).to_not have_content("Update")
  end

  scenario "other user tries to update upload tags but can't", :js => true do
    other_user = create(:user)
    log_in(other_user)
    visit upload_path(upload)
    expect(page).to_not have_content "Edit Tags"
  end

  scenario "click on tag and see all uploads with that tag" do
    
  end

  scenario "search for uploads by tag and return all images related to tag" do
  end

  scenario "show the most popular tags" do
  end

  scenario "show the most needed tags" do
  end


end