require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  user = FactoryGirl.create(:user)
  other_user = FactoryGirl.create(:user)

  it "gets new user page" do
    get :new
    expect(response).to have_http_status(:ok)
  end

  it "redirects edit when not logged in" do
    get :edit, id: user.id
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "redirects update when not logged in" do
    get :update, id: user.id, user: build(:user, email: "sample@example.com")
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "redirects edit when logged in as wrong user" do
    log_in_as(user)
    get :edit, id: other_user.id
    expect(flash).to be_empty
    expect(response).to redirect_to(root_url)
  end
end
