require 'rails_helper'

RSpec.describe UploadModerationController, type: :controller do

  subject(:admin) { create(:admin) }
  subject(:nonadmin) { create(:user) }
  subject(:unapproved) { create(:upload) }
  subject(:approved) { create(:upload, approved: true) }

  it "approves unapproved upload" do
    log_in_as(admin)
    expect(unapproved.approved?).to eq(false)
    patch :update, id: unapproved, upload: { approved: true }
    expect(unapproved.reload.approved?).to eq(true)
  end

  it "disapproves approved upload" do
    log_in_as(admin)
    expect(approved.approved?).to eq(true)
    patch :update, id: approved, upload: { approved: false }
    expect(approved.reload.approved?).to eq(false)  
  end

  it "should redirect update when not logged in" do
    patch :update, id: unapproved, upload: { approved: true }
    expect(response).to redirect_to login_url
    expect(unapproved.approved?).to eq(false) 
  end

  it "should redirect when not admin" do
    log_in_as(nonadmin)
    patch :update, id: unapproved, upload: { approved: true }
    expect(response).to redirect_to root_url
    expect(unapproved.approved?).to eq(false) 
  end

end
