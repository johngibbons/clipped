class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

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
      #upload is one of the current users'
      unless current_user.nil?
        user_uploads = current_user.uploads.find_by(id: params[:id])
      end

      #upload is one of the current users' or is approved
      unless @upload.approved? || !user_uploads.nil?
        flash[:error] = "You don't have access to that image"
        redirect_to request.referrer || root_url
      end
    end
end
