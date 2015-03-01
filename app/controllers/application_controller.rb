class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pundit

  private

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

    def approved_uploads
      @uploads = Upload.where(approved: true)
    end

    def approved?
      #upload is one of the current users' or is approved
      unless @upload.approved? || own_uploads? || current_user.admin?
        flash[:error] = "You don't have access to that image"
        redirect_to request.referrer || root_url
      end
    end

    # Returns true if uploads belong to user
    def own_uploads?
      !current_user.uploads.find_by(id: params[:id]).nil?
    end
end
