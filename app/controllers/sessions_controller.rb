class SessionsController < ApplicationController
  def new
  end

  def create
    if auth_hash.nil?
      @user = User.find_by(email: params[:session][:email].downcase)
    else
      @user = User.from_omniauth(auth_hash)
    end
    if params[:session].nil? || @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        remember @user
        redirect_back_or @user
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:error] = message
        redirect_to root_url
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
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
