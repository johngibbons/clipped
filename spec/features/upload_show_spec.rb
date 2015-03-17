require "rails_helper"

RSpec.feature "Upload show page", :type => :feature do

  subject(:user) { create(:user) }
  subject(:upload) { create(:upload, approved: true) }

  context "user is logged in as admin" do

    before(:each) do
      @admin = create(:user, admin: true)
      log_in(@admin)
    end

    scenario "admin updates upload tags", :js => true do
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

    scenario "click on tag and see all uploads with that tag" do
      second_upload = create(:upload, approved: false)
      upload.tag_list = "first, second, third"
      second_upload.tag_list = "second"
      upload.save!
      second_upload.save!
      visit upload_path(upload)
      expect(page).to have_selector(".tag", count: 3)
      expect(page).to have_content "second"
      click_link "second"
      expect(page).to have_selector(".upload-thumb", count: 2)
    end

    scenario "other user tries to update upload tags but can't", :js => true do
      other_user = create(:user)
      log_in(other_user)
      visit upload_path(upload)
      expect(page).to_not have_content "Edit Tags"
    end

    scenario "admin updates upload perspective", :js => true do
      visit upload_path(upload)
      expect(page).to have_content "NOT APPLICABLE"
      expect(page).to have_content "Edit Perspective"
      click_link "Edit Perspective"
      expect(page).to have_content "BACK"
      expect(page).to have_content "SIDE FRONT"
      page.find('label', text: "ABOVE").click
      click_button "Update Upload"
      expect(page).to have_content "ABOVE"
      expect(page).to_not have_content "SIDE FRONT"
      second_upload = create(:upload, approved: false, perspective: :above)
      click_link "Above"
      expect(page).to have_selector(".upload-thumb", count: 2)
    end

  end

  context "upload owner is logged in" do

    before(:each) do
      @owner = user
      upload.user = @owner
      upload.save!
      log_in(@owner)
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

    scenario "click on tag and see all uploads with that tag" do
      second_upload = create(:upload, approved: false)
      upload.tag_list = "first, second, third"
      second_upload.tag_list = "second"
      upload.save!
      second_upload.save!
      visit upload_path(upload)
      expect(page).to have_selector(".tag", count: 3)
      expect(page).to have_content "second"
      click_link "second"
      expect(page).to have_selector(".upload-thumb", count: 1)
    end

    scenario "uploader updates upload perspective", :js => true do
      visit upload_path(upload)
      expect(page).to have_content "NOT APPLICABLE"
      expect(page).to have_content "Edit Perspective"
      click_link "Edit Perspective"
      expect(page).to have_content "BACK"
      expect(page).to have_content "SIDE FRONT"
      page.find('label', text: "ABOVE").click
      click_button "Update Upload"
      expect(page).to have_content "ABOVE"
      expect(page).to_not have_content "SIDE FRONT"
      second_upload = create(:upload, approved: false, perspective: :above)
      click_link "Above"
      expect(page).to have_selector(".upload-thumb", count: 1)
    end

  end

  context "guest user (no user logged in)" do

    before(:each) do
      upload.tag_list = "first, second, third"
      second_upload = create(:upload, approved: false)
      second_upload.tag_list = "second"
      upload.save!
      second_upload.save!
    end

    scenario "guest user visits upload" do
     visit upload_path(upload)
     expect(page).to_not have_content "Edit Tags"
     expect(page).to have_selector(".tag", count: 3)
     expect(page).to have_content "third"
     expect(page).to_not have_content("Update")
    end

    scenario "click on tag and see all uploads with that tag" do
      visit upload_path(upload)
      expect(page).to have_selector(".tag", count: 3)
      expect(page).to have_content "second"
      click_link "second"
      expect(page).to have_selector(".upload-thumb", count: 1)
    end

    scenario "guest user can't upload perspective", :js => true do
      upload.perspective = :above
      upload.save!
      visit upload_path(upload)
      expect(page).to have_content "ABOVE"
      expect(page).to_not have_content "Edit Perspective"
      expect(page).to_not have_content "SIDE FRONT"
      second_upload = create(:upload, approved: false, perspective: :above)
      click_link "Above"
      expect(page).to have_selector(".upload-thumb", count: 1)
    end

  end

  scenario "search for uploads by tag and return all images related to tag" do
  end

  scenario "show the most popular tags" do
  end

  scenario "show the most needed tags" do
  end


end