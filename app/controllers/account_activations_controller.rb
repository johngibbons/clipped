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
end
