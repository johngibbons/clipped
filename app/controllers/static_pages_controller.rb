class StaticPagesController < ApplicationController

  def home
    @uploads = StaticPagesPolicy::Scope.new(current_user, Upload).resolve
    @most_popular = @uploads.sorted_by_weighted_score

    @most_used_tags = ActsAsTaggableOn::Tag.most_used(30)
  end

  def help
  end

  def about
  end

  def contact
  end
end
