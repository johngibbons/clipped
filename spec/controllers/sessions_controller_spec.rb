require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  subject(:user) { build(:user) }

  it "successfully gets new session" do
    get :new
    expect(response).to have_http_status(:success)
  end

  it "creates new user using omniauth" do
    request.env["omniauth.auth"] = mock_auth_hash
    expect do
      get :create, :provider => "facebook"
    end.to change{ User.count }.by(1)
    user = User.last
    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(user_path(session[:user_id]))
  end

  it "handles username for duplicate email using omniauth" do
    create(:user, {username: "mockemailabcdefghijk"}) #omniauth uses mockemailabcdefghijk@sample.com
    request.env["omniauth.auth"] = mock_auth_hash
    expect do
      get :create, :provider => "facebook"
    end.to change{ User.count }.by(1)
    user = User.last
    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(user_path(session[:user_id]))
  end

  it "logs in user using email and password" do
    user.save!
    get :create, session: { username_or_email: user.email,
                            password: user.password }
    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(user_path(session[:user_id]))
  end

  it "logs in user using username and password" do
    user.save!
    get :create, session: { username_or_email: user.username,
                            password: user.password }
    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(user_path(session[:user_id]))
  end

  it "doesn't log in user with incorrect password" do
    user.save!
    get :create, session: { username_or_email: user.email,
                            password: "wrongpassword" }
    expect(session[:user_id]).to eq(nil)
    expect(response).to render_template("sessions/new")
  end

  it "destroys authentication" do
    request.env["omniauth.auth"] = mock_auth_hash
    #log in
    get :create, :provider => "facebook"

    user = User.last
    expect(session[:user_id]).to eq(user.id)

    #log out
    get :destroy
    expect(session[:user_id]).to eq(nil)
  end
end
