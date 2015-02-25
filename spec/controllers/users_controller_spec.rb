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
    expect(current_user).to eq(user)
    get :edit, id: other_user.id
    expect(flash).to be_empty
    expect(response).to redirect_to(root_url)
  end

  it "redirects update when logged in as wrong user" do
    log_in_as(user)
    get :update, id: other_user.id, user: { email: other_user.email }
    expect(flash).to be_empty
    expect(response).to redirect_to(root_url)
  end

  it "redirects index when not logged in" do
    get :index
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

  it "allows guest users to view other users" do
    expect(session[:user_id]).to eq(nil)
    expect(current_user).to eq(:guest_user)
  end

  describe "showing user profile" do
    subject(:upload_approved) { build(:upload, user_id: user, approved: true) }
    subject(:upload_unapproved) { build(:upload, user_id: user, approved: false) }

    context "viewing own profile" do
      before :example do
        log_in_as(user)
        get :show, id: user
        user.stub(:upload) do |arg|
          if arg == :approved
            
          elsif arg == :that
            "got that"
          end
        end
    
    object.foo(:this).should eq("got this")
    object.foo(:that).should eq("got that")
      end

      it "shows all uploads" do
        expect(Upload.all.count).to eq(2)
        expect(response.body).to have_css(".unapproved")
      end
    end
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
      expect(flash).to be_empty
      expect(response).to redirect_to(root_url)
    end

    it "allows destroy when admin" do
      admin = create(:admin)
      log_in_as(admin)
      expect do
        delete :destroy, id: @user
      end.to change{ User.count }.by(-1)
      expect(flash).to_not be_empty
      expect(response).to redirect_to(users_url)
    end
  end
end
