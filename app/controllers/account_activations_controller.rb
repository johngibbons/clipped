class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    token = params[:id]
    if user.activate(token)
      log_in user
      flash[:success] = "Account activated"
      redirect_to user
    else
      flash[:error] = "Invalid activation link"
      redirect_to root_url
    end
  end

  def new
  end

  def create
    @user = User.find_by(email: params[:account_activation][:email])
    @user.create_activation_digest
    if @user
      @user.send_activation_email
      flash[:notice] = "Please check your email to activate your account."
      redirect_to root_url
    else
      flash[:error] = "Invalid email"
      redirect_to new_account_activation_path
    end
  end

end
