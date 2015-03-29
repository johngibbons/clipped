require "rails_helper"

RSpec.feature "User logs in", :type => :feature do

  scenario "no user has signed in" do
    visit root_path
    expect(page).to have_content "Login"
  end
end