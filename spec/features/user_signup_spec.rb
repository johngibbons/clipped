require "rails_helper"

RSpec.feature "User signs up for account", :type => :feature do

  scenario "with Omniauth" do
    visit signup_path
    expect(page).to have_content("Sign Up With Facebook")
    mock_auth_hash
    click_link "Sign Up With Facebook"
    expect(page).to have_content("mockuser")  # user name
  end

  scenario "with invalid Omniauth" do
    OmniAuth.config.mock_auth[:facebook] = {"invalid" => "hash"}
    visit signup_path
    click_link "Sign Up With Facebook"
    expect(page).to have_content("Facebook")
  end

  scenario "with valid email and password" do
    visit signup_path
    sign_up_with("email@sample.com", "password")
    expect(page).to have_content("check your email")
  end

end