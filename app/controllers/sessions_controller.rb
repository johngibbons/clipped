class SessionsController < ApplicationController
  before_action :store_referral, only: :new

  def new
    unless request.query_string.blank?
      sso = SingleSignOn.parse(request.query_string, ENV["SSO_SECRET"])
      session[:sso] = sso
    end
  end

  def create
    if session[:sso]
      sso = SingleSignOn.new
      sso.nonce = session[:sso]["nonce"]
    end
    @user = FindUserToLogin.call(auth_hash: auth_hash, params: params)
    login = AuthenticateUser.new(user: @user, params: params, auth_hash: auth_hash)
    if login.success?
      log_in @user
      remember @user
      if sso
        sso.name = @user.name
        sso.email = @user.email
        sso.username = @user.username
        sso.external_id = @user.id
        sso.avatar_url = @user.avatar.url
        sso.avatar_force_update = true
        sso.sso_secret = ENV["SSO_SECRET"]

        redirect_to sso.to_url("http://community.clipped.io/session/sso_login")
      else
        redirect_back_or @user
      end
    else
      flash.now[:error] = login.error
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def store_referral
    session[:referral_url] = request.referrer if request.get?
  end

end
