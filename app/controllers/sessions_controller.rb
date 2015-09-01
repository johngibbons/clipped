class SessionsController < ApplicationController
  def new
  end

  def create
    @user = FindUserToLogin.call(auth_hash: auth_hash, params: params)
    login = AuthenticateUser.new(user: @user, params: params, auth_hash: auth_hash)
    if login.success?
      log_in @user
      remember @user
      redirect_back_or @user
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

end
