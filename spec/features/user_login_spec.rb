require "rails_helper"

RSpec.feature "User logs in", :type => :feature do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }

  before(:example) do
    visit login_path
  end

  scenario "with Omniauth" do
    expect(page).to have_content("Log In With")
    mock_auth_hash
    click_link "Log In With Facebook"
    expect(page).to have_content("mockuser")
  end

  scenario "with valid user and email" do
    log_in(user)
    expect(page).to have_content(user.name)
    expect(page).to have_css(".user_profile")
  end

  scenario "with invalid user and email" do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: other_user.password
    click_button 'Log In'
    expect(page).to have_content("Log In With")
  end
  
end