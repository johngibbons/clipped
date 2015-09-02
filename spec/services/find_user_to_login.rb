require 'rails_helper'
require './app/services/find_user_to_login'

describe FindUserToLogin do
  before do

    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => "amanda.m.tharp@gmail.com",
        'name' => "Amanda Tharp"
      }
    }

    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

  end

  it "converts special chars in omniauth email to underscores" do
    VCR.use_cassette('omniauth_username_creation', match_requests_on: [:host]) do
      user = FindUserToLogin.call(auth_hash: Rails.application.env_config["omniauth.auth"])
      expect(user.username).to eq("amanda_m_tharp")
    end
  end

end
