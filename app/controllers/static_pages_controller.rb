class StaticPagesController < ApplicationController
  before_action :approved_uploads, only: :home

  def home
    @most_recent  = @uploads.take(30)
    @most_viewed  = @uploads.sorted_by_views.limit(10)
    @most_liked   = @uploads.sorted_by_likes.limit(10)
    @most_popular = @uploads.sorted_by_weighted_score
  end

  def help
  end

  def about
  end

  def contact
  end
end
