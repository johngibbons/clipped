require "rails_helper"

RSpec.feature "Upload show page", :type => :feature do

  subject(:non_admin) { create(:user) }
  subject(:upload) { create(:upload, approved: true) }
  subject(:admin) { create(:user, admin: true) }

  context "user is logged in as admin" do

    before do
      log_in(admin)
    end

    scenario "admin updates upload tags", js: true do
      visit upload_path(upload)
      expect(page).to have_content "Edit Tags"
      page.find(".edit-tags").click
      expect(page).to have_field "upload_tag_list"
      fill_in "upload_tag_list", with: "sample tag, another, a third,"
      page.find(".edit-tags").click
      expect(page).to have_selector(".tag", count: 3)
      expect(page).to have_content "sample tag"
      expect(page).to_not have_content("Done")
    end

    scenario "click on tag and see all uploads with that tag", solr: true do
      second_upload = create(:upload, approved: false)
      upload.tag_list = "first, second, third"
      second_upload.tag_list = "second"
      upload.save!
      second_upload.save!
      visit upload_path(upload)
      expect(page).to have_css(".tag", count: 3)
      expect(page).to have_content "second"
      click_link "second"
      expect(page).to have_css(".search.index")
      expect(page).to have_css(".upload-thumb", count: 1)
    end

    scenario "admin updates upload perspective", js: true do
      visit upload_path(upload)
      expect(page).to have_content "Not applicable"
      click_link "Edit"
      select "Above", from: "upload_perspective"
      click_button "Update"
      expect(page).to have_content "Above"
      expect(page).to_not have_content "Not applicable"
    end

  end

  context "upload owner is logged in" do

    before do
      owner = non_admin
      upload.user = owner
      upload.save!
      log_in(owner)
    end

    scenario "upload owner updates upload tags", js: true do
     visit upload_path(upload)
     expect(page).to have_content "Edit Tags"
     page.find(".edit-tags").click
     expect(page).to have_field "upload_tag_list"
     fill_in "upload_tag_list", with: "sample tag, another, a third,"
     page.find(".edit-tags").click
     expect(page).to have_selector(".tag", count: 3)
     expect(page).to have_content "sample tag"
     expect(page).to_not have_content("Done")
    end

    scenario "uploader updates upload perspective", js: true do
      visit upload_path(upload)
      expect(page).to have_content "Not applicable"
      expect(page).to have_content "Edit"
      click_link "Edit"
      select "Above", from: "upload_perspective"
      click_button "Update"
      expect(page).to have_content "Above"
      expect(page).to_not have_content "Not applicable"
    end

    scenario "other user tries to update upload tags but can't" do
      other_user = create(:user)
      log_in(other_user)
      visit upload_path(upload)
      expect(page).to_not have_content "Edit Tags"
    end

  end

  context "guest user (no user logged in)" do

    scenario "guest user can't edit upload attributes" do
      visit upload_path(upload)
      expect(page).to_not have_content "Edit Tags"
      expect(page).to_not have_content "Edit"
    end

  end

end
