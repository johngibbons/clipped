class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    #determines whether user is logged in and if not directs them to login page
    def logged_in_user
      unless logged_in?
        store_location
        flash[:error] = "Please log in."
        redirect_to login_url
      end
    end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || login_path)
    end

end
