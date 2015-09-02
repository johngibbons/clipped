require "rails_helper"

RSpec.feature "User signs up for account", :type => :feature do

  before(:example) do
    visit signup_path
  end

  scenario "with Omniauth" do
    VCR.use_cassette('facebook_login', match_requests_on: [:host]) do
      expect(page).to have_content("Sign Up With Facebook")
      mock_auth_hash
      click_link "Sign Up With Facebook"
      expect(page).to have_content("mockuser")  # user name
      expect(page).to have_css(".user_profile") #skips email validation
    end
  end

  scenario "with invalid Omniauth" do
    OmniAuth.config.mock_auth[:facebook] = {"invalid" => "hash"}
    click_link "Sign Up With Facebook"
    expect(page).to have_content("Facebook")
    expect(page).to have_css(".flash-error")
  end

  scenario "with valid email and password" do
    VCR.use_cassette('user_signup', match_requests_on: [:host]) do
      sign_up_with(username: "sampleuser", email: "email@sample.com", password: "password")
      expect(page).to have_content("check your email")
    end
  end

end
