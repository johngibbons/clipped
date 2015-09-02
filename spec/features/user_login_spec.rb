require "rails_helper"

RSpec.feature "User logs in", :type => :feature do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }

  before do
    visit login_path
  end

  scenario "with Omniauth" do
    expect(page).to have_content("Log In With")
    VCR.use_cassette('facebook_login', match_requests_on: [:host]) do
      mock_auth_hash
      click_link "Log In With Facebook"
      expect(page).to have_content("mockuser")
      expect(page).to have_css(".user_profile")
    end
  end

  scenario "with regular account and then with Omniauth" do
    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => user.email,
        'name' => user.name
      }
    }
    click_link "Log In With Facebook"
    expect(page).to have_content(user.name)
    expect(page).to have_css(".user_profile")
  end

  scenario "with valid user and email" do
    log_in(user)
    expect(page).to have_content(user.name)
    expect(page).to have_css(".user_profile")
  end

  scenario "with invalid user and email" do
    fill_in 'Username or email', with: user.email
    fill_in 'Password', with: other_user.password
    click_button 'Log In'
    expect(page).to have_content("Log In With")
    expect(page).to have_css(".flash-error")
  end

  scenario "previously omniauth logged in, now with invalid email and password" do
    user.provider = "facebook"
    user.save!
    fill_in 'Username or email', with: user.email
    fill_in 'Password', with: other_user.password
    click_button 'Log In'
    expect(page).to have_content("Log In With")
    expect(page).to have_css(".flash-error")
  end

  scenario "with email that doesn't exist" do
    fill_in 'Username or email', with: "some.random@example.com"
    fill_in 'Password', with: "password"
    click_button 'Log In'
    expect(page).to have_content("Log In With")
    expect(page).to have_css(".flash-error")
  end

  scenario "before activating account" do
    user.activated = false
    user.save!
    log_in(user)
    expect(page).to have_content "Account not activated."
    expect(page).to have_content "Log In With"
    expect(page).to have_css(".flash-error")
  end

  scenario "with missing profile avatar" do
    user_no_avatar = FactoryGirl.create(:user, avatar: "")
    log_in(user_no_avatar)
    expect(page).to have_css("#profile-avatar")
    expect(page).to have_css(".user_profile")
  end
end
