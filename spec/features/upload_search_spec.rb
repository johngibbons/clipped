require "rails_helper"

RSpec.feature "Upload Search", :type => :feature do

  before(:each) do
    created_uploads = create_list(:approved_upload, 35)
    @uploads = Upload.all
  end

  scenario "user browses all images" do
    visit uploads_path
    expect(page).to have_selector('.upload-thumb', count: 30)
    expect(page).to have_selector('.pagination')
  end

  scenario "user has clicked on a tag", solr: true do
    expect(@uploads.length).to eq(35)
    upload1 = @uploads.first
    upload2 = @uploads.last
    upload3 = @uploads.offset(3).take
    upload1.tag_list = upload2.tag_list = upload3.tag_list = "first, second, third"
    upload1.save!
    upload2.save!
    upload3.save!
    Sunspot.commit
    @tag_name = "first"
    visit tag_path(@tag_name)
    expect(page).to have_selector('.upload-thumb', count: 3)
  end
end