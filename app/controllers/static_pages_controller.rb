class StaticPagesController < ApplicationController
  layout "uploads_index", only: :home


  def home
    @uploads = StaticPagesPolicy::Scope.new(current_user, Upload).resolve
    @most_popular = @uploads.sorted_by_weighted_score
    @most_used_tags = Upload.where(approved: true).tag_counts.order(taggings_count: :desc).limit(50)
  end

  def help
  end

  def about
  end

  def contact
  end
end
