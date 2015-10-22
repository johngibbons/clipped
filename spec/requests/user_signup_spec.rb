require 'rails_helper'

RSpec.describe "User signs up", :type => :request do
  let(:user) { create(:user) }

  it "signs up with valid username email and password", solr: true do
    ActionMailer::Base.deliveries = nil
    get signup_path
    expect(response).to render_template(:new)
    VCR.use_cassette('user_signup', match_requests_on: [:host]) do
      expect do
        post users_path, user: { username: "sampleuser",
                                email: "sample@example.com",
                                password: "password",
                                password_confirmation: "password" }
      end.to change{ User.count }.by(1)
    end

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    user = assigns(:user)
    expect(user).to_not be_activated
    expect(response).to redirect_to(root_url)
    log_in_as(user)
    get edit_account_activation_url(user.activation_token, email: user.email)
    expect(user.reload).to be_activated
  end
end
