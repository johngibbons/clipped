require "rails_helper"

RSpec.feature "Update User Score", :type => :feature do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }
  subject(:upload) { create(:upload, approved: true) }

  before(:example) do
    log_in(user)
  end 

  scenario "updates on favorite or unfavorite" do
    visit upload_path(upload)
    expect do
      click_button "favorite"
    end.to change{upload.reload.user.weighted_score}

    expect do
      click_button "unfavorite"
    end.to change{upload.reload.user.weighted_score}
  end

  scenario "updates on download" do
    visit upload_path(upload)
    expect do
      click_button "Download"
    end.to change{upload.reload.downloads}.by(1)
  end

end