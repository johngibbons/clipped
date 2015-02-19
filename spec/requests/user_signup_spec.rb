require 'rails_helper'

RSpec.describe "User signs up", :type => :request do

  let(:user) { create(:user) }

  it "signs up with valid email and password" do
    get signup_path
    expect(response).to render_template(:new)

    expect do
      post users_path, user: { email: "sample@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end.to change{ User.count }.by(1)

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    user = assigns(:user)
    expect(user).to_not be_activated
    expect(response).to redirect_to(root_url)
    log_in_as(user)
    get edit_account_activation_path("invalid token")
  end
end