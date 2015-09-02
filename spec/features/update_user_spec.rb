require "rails_helper"

RSpec.feature "Update User", :type => :feature do

  subject(:user) { create(:user) }

  before(:each) do
    log_in(user)
    visit edit_user_path(user)
  end

  scenario "User enters invalid new password and doesn't update" do
    fill_in 'Email', with: user.email
    fill_in "Password", with: "pass"
    fill_in "Password Confirmation", with: "pass"
    click_button "Save Changes"
    expect(page).to have_content("Password")
    expect(page).to have_css(".flash-error")
  end

  scenario "User enters invalid new email and doesn't update" do
    fill_in 'Email', with: "invalid.email@sample"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    click_button "Save Changes"
    expect(page).to have_content("Password")
    expect(page).to have_css(".flash-error")
  end

  scenario "User enters valid email and password and updates" do
    fill_in 'Email', with: user.email
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    click_button "Save Changes"
    expect(page).to have_content("Profile successfully updated")
    expect(page).to have_css(".flash-success")
  end

  scenario "User enters no password and updates email only" do
    pass = user.password_digest
    fill_in "Email", with: "new@sample.com"
    click_button "Save Changes"
    expect(page).to have_content("Profile successfully updated")
    expect(page).to have_css(".flash-success")
    expect(user.reload.email).to eq("new@sample.com")
    expect(user.reload.password_digest).to eq(pass)
  end

  scenario "User enters no email and updates password only" do
    pass = user.password_digest
    old_email = user.email
    fill_in "Password", with: "newpassword"
    fill_in "Password Confirmation", with: "newpassword"
    click_button "Save Changes"
    expect(page).to have_content("Profile successfully updated")
    expect(page).to have_css(".flash-success")
    expect(user.reload.password_digest).to_not eq(pass)
    expect(user.reload.email).to eq(old_email)
  end

  scenario "User enters no email and updates username only" do
    old_email = user.email
    old_username = user.username
    fill_in "Username", with: "newusername"
    click_button "Save Changes"
    expect(page).to have_content("Profile successfully updated")
    expect(page).to have_css(".flash-success")
    expect(user.reload.username).to_not eq(old_username)
    expect(user.reload.email).to eq(old_email)
  end

end
