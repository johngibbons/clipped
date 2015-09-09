class SessionsController < ApplicationController
  before_action :store_referral, only: :new

  def new
  end

  def create
    @user = FindUserToLogin.call(auth_hash: auth_hash, params: params)
    sso = SsoHandler.new(user: @user, auth_hash: auth_hash, params: params)
    login = AuthenticateUser.new(user: @user, params: params, auth_hash: auth_hash)
    if login.success?
      log_in @user
      remember @user
      if sso.forum_origin?
        redirect_to generate_url( ENV["FORUM_URL"], sso.return_params )
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
