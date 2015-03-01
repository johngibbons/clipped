class SessionsController < ApplicationController
  def new
  end

  def create
    @service = LogInUsers.new(auth_hash, session_params)
    @user = @service.get_user

    if @service.login(@user)
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

  def session_params
    @guest = GuestUser.new
    params[:session] ||= { password: @guest.password, email: @guest.email }
    params
  end
end