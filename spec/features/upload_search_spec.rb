require "rails_helper"

RSpec.feature "Upload Search", :type => :feature do

  before(:each) do
    created_uploads = create_list(:approved_upload, 35)
    @uploads = Upload.all
    expect(@uploads.length).to eq(35)
    @upload1 = @uploads.first
    @upload2 = @uploads.last
    @upload3 = @uploads.offset(3).take
    @upload1.tag_list = @upload2.tag_list = @upload3.tag_list = "first, second, third"
    @upload1.perspective = @upload2.perspective = @upload3.perspective = "side"
    @upload1.category = @upload2.category = "animals"
    @upload3.category = "people"
    @upload1.save!
    @upload2.save!
    @upload3.save!
  end

  scenario "user browses all images" do
    visit uploads_path
    expect(page).to have_selector('.upload-thumb', count: 30)
    expect(page).to have_selector('.pagination')
  end

  scenario "user has clicked on a tag, then on a perspective, then on a category, searches for keyword", solr: true do
    Sunspot.commit
    visit upload_path(@upload1)
    click_link "second"
    expect(page).to have_selector('.upload-thumb', count: 3)
    visit upload_path(@upload2)
    click_link "Side"
    expect(page).to have_selector('.upload-thumb', count: 3)
    visit upload_path(@upload2)
    click_link "Animals"
    expect(page).to have_selector('.upload-thumb', count: 2)
    visit root_path
    fill_in "upload-search", with: "third"
    click_button "search-submit"
    expect(page).to have_selector('.upload-thumb', count: 3)
  end

  scenario "user searches from home page", solr: true, js: true do
    Sunspot.commit
    visit root_path
    fill_in "upload-search", with: "second"
    find('#perspective-filter').find('label', text: "ALL").click
    find('label', text: "Front").click
    click_button "search-submit"
    expect(page).to_not have_selector('.upload-thumb')
    find('#category-filter').find('label', text: "ALL").click
    find('label', text: "Animals").click
    click_button "search-submit"
    expect(page).to have_selector(".upload-thumb", count: 2)
  end

end