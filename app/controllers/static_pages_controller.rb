class StaticPagesController < ApplicationController
  def home
    @recent_uploads = Upload.take(30)
    uploads = Upload.all
    @most_viewed = uploads.reorder(views: :desc).limit(30)
  end

  def help
  end

  def about
  end

  def contact
  end
end
