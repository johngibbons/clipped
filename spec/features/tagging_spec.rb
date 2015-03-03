require "rails_helper"

RSpec.feature "Image tagging", :type => :feature do

  subject(:user) { create(:user) }
  subject(:upload) { create(:upload, user: user) }

  before(:example) do
    log_in(user)
  end 

  scenario "upload owner updates upload tags" do
   visit upload_path(upload)
   expect(page).to have_content "Edit Tags"
   page.find("#edit-tags-link").click
   expect(page).to have_field "Tags"
   fill_in "Tags", with: "sample tag, another, a third"
   click_button "Update Tags"
   expect(upload.reload.tags.count).to eq(3)
  end

  scenario "admin updates upload tags" do
  end

  scenario "other user tries to update upload tags but can't" do
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