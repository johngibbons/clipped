require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  subject(:user) { create(:user) }
  subject(:other_user) { create(:user) }

  it "activates authenticated user" do
    expect(user).to_not be_activated
    get :edit, id: user.activation_token, email: user.email
    expect(user.reload).to be_activated
    expect(flash[:success]).to_not be_empty
    expect(response).to redirect_to(user)
  end

  it "doesn't activate wrong user" do
    expect(user).to_not be_activated
    get :edit, id: other_user.activation_token, email: user.email
    expect(user.reload).to_not be_activated
    expect(flash[:error]).to_not be_empty
    expect(response).to redirect_to(root_url)
  end

end
