class StaticPagesController < ApplicationController

  def home
    @uploads = StaticPagesPolicy::Scope.new(current_user, Upload).resolve
    @most_recent  = @uploads.take(30)
    @most_viewed  = @uploads.sorted_by(:views).limit(10)
    @most_liked   = @uploads.sorted_by(:likes_count).limit(10)
    @most_popular = @uploads.sorted_by_weighted_score
  end

  def help
  end

  def about
  end

  def contact
  end
end
