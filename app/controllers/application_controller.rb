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

  def sort_by_likes(uploads)
    uploads.reorder(likes_count: :desc, created_at: :desc).limit(30)
  end

  def sort_by_views(uploads)
    uploads.reorder(views: :desc, created_at: :desc).limit(30)
  end
end
