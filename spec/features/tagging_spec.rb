require "rails_helper"

RSpec.feature "Image tagging", :type => :feature do
  before(:example) do
    @user = create(:user)
    @upload = create(:upload)
    log_in(@user)
  end 

  scenario "update upload tags" do
   
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