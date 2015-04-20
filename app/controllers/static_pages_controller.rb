class StaticPagesController < ApplicationController
  layout "no_container", only: :home


  def home
    @uploads = StaticPagesPolicy::Scope.new(current_user, Upload).resolve
    @most_popular = @uploads.take(10)
    @most_used_tags = Upload.where(approved: true).tag_counts.order(taggings_count: :desc).limit(50)

    @user_search = User.search do
      with :activated, true
      order_by :weighted_score, :desc
      order_by :created_at, :desc
    end

    @users = @user_search.results.take(8)
    @total_results = @user_search.total
  end

  def help
  end

  def about
  end

  def contact
  end
end
