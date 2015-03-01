require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    subject(:user) { build(:user) }

    it "successfully gets new session" do
      get :new
      expect(response).to have_http_status(:success)
    end
end
