class StaticPagesController < ApplicationController
  def home
    @most_recent  = Upload.take(30)
    @most_viewed  = Upload.sorted_by_views.limit(10)
    @most_liked   = Upload.sorted_by_likes.limit(10)
    @most_popular = Upload.sorted_by_weighted_score
  end

  def help
  end

  def about
  end

  def contact
  end
end
