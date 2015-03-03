require 'rails_helper'

RSpec.describe "Password Reset", :type => :request do
  let(:user) { create(:user) }

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context "with invalid email" do
    it "redirects doesn't send email and redirects back to password resets page" do
      get new_password_reset_path
      expect(response).to render_template("password_resets/new")
      post password_resets_path, password_reset: { email: "" }
      expect(flash).to_not be_empty
      expect(response).to render_template("password_resets/new")
    end
  end

  context "valid email" do
    it "delivers password reset email and redirects to root" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      expect(flash).to_not be_empty
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(response).to redirect_to(root_url)
      expect(assigns(:user)).to eq(user)
    end
  end

  context "wrong email sent to password reset" do
    it "doesn't reset password and redirects" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)
      get edit_password_reset_path(id: returned_user.reset_token, email: "")
      expect(response).to redirect_to(root_url)
    end
  end

  context "unactivated user" do
    it "doesn't reset password and redirects" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)
      returned_user.toggle!(:activated)
      expect(returned_user.reload.activated?).to eq(false)
      get edit_password_reset_path(returned_user.reset_token, email: returned_user.email)
      expect(response).to redirect_to(root_url)
    end
  end

  context "right email, wrong token" do
    it "doesn't reset password and redirects" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)      
      get edit_password_reset_path('wrong token', email: returned_user.email)
      expect(response).to redirect_to(root_url)
    end
  end

  context "right email, right token" do
    it "sends user to reset password page" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)      
      get edit_password_reset_path(returned_user.reset_token, email: returned_user.email)
      expect(response).to render_template "password_resets/edit"
    end
  end

  context "invalid password and confirmation" do
    it "doesn't update password and generates error" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)   
      patch password_reset_path(returned_user.reset_token),
        email: returned_user.email,
        user: { password:               "foobazer",
                password_confirmation:  "barquuxer" }
      expect(response).to render_template "password_resets/edit"
      expect(flash).to_not be_empty
      expect(returned_user.reload.password).to eq(nil)
    end
  end

  context "blank password" do
    it "doesn't update password and generates error" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)   
      patch password_reset_path(returned_user.reset_token),
      email: returned_user.email,
      user: { password:              " ", 
              password_confirmation: "foobared" }
      expect(flash).to_not be_empty
      expect(response).to render_template "password_resets/edit"
    end
  end

  context "expired password reset token" do
    it "doesn't reset password and redirects" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user) 
      returned_user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(returned_user.reset_token),
        email: returned_user.email,
        user: { password:   "password",
                password_confirmation: "password" }
      expect(flash).to_not be_empty
      expect(response).to redirect_to new_password_reset_url
    end
  end

  context "valid password and confirmation" do
    it "updates password and redirects to user profile" do
      get new_password_reset_path
      post password_resets_path, password_reset: { email: user.email }
      returned_user = assigns(:user)   
      patch password_reset_path(returned_user.reset_token),
        email: returned_user.email,
        user: { password:               "newpassword",
                password_confirmation:  "newpassword" }
      expect(flash).to_not be_empty
      expect(response).to redirect_to(returned_user)
      expect(returned_user.reload.authenticated?("password", "newpassword")).to eq(true)
    end
  end
end