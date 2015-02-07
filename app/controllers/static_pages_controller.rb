class StaticPagesController < ApplicationController
  def home
    uploads = Upload.all
    @most_recent = Upload.take(30)
    @most_viewed = sort_by_views(uploads)
    @most_liked = sort_by_likes(uploads)
    
  end

  def help
  end

  def about
  end

  def contact
  end
end
