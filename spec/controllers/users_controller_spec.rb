require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }
  subject(:guest) { build(:guest_user) }

  it "gets new user page" do
    get :new
    expect(response).to have_http_status(:ok)
  end

  it "redirects edit when not logged in" do
    get :edit, id: user.username
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "redirects update when not logged in" do
    get :update, id: user.username, user: build(:user, email: "sample@example.com")
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "redirects edit when logged in as wrong user" do
    log_in_as(user)
    expect(current_user).to eq(user)
    get :edit, id: other_user.username
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "redirects update when logged in as wrong user" do
    log_in_as(user)
    get :update, id: other_user.username, user: { email: other_user.email }
    expect(flash).to_not be_empty
    expect(response).to redirect_to(login_url)
  end

  it "doesn't allow the admin attribute to be edited from the web" do
    log_in_as(other_user)
    expect(other_user.admin?).to eq(false)
    patch :update, id: other_user, user: { password: "password",
                                           password_confirmation: "password",
                                           admin: 1 }
    expect(other_user.reload.admin?).to eq(false) 
  end

  describe "handles deleting users correctly" do
    before :example do
      @user = user
    end

    it "redirects destroy when not logged in" do
      expect(User.count).to eq(1)
      expect do
        delete :destroy, id: @user
      end.to_not change{ User.count }
      expect(flash).to_not be_empty
      expect(response).to redirect_to(login_url)
    end

    it "redirects destroy when logged in but not admin" do
      log_in_as(other_user)
      expect(User.count).to eq(2)
      expect do
        delete :destroy, id: @user
      end.to_not change{ User.count }
      expect(flash).to_not be_empty
      expect(response).to redirect_to(login_url)
    end

    it "allows destroy when admin" do
      admin = create(:admin)
      log_in_as(admin)
      VCR.use_cassette('destroy_user', match_requests_on: [:host]) do
        expect do
          delete :destroy, id: @user
        end.to change{ User.count }.by(-1)
        expect(flash).to_not be_empty
        expect(response).to redirect_to(root_url)
      end
    end

    it "allows destroy when self" do
      log_in_as(@user)
      VCR.use_cassette('destroy_user', match_requests_on: [:host]) do
        expect do
          delete :destroy, id: @user
        end.to change { User.count }.by(-1)
        expect(flash).to_not be_empty
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
