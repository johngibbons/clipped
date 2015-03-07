class SearchController < ApplicationController

  def index
    @viewable_uploads = StaticPagesPolicy::Scope.new(current_user, Upload).resolve

    @search = @viewable_uploads.search do
      fulltext params[:search] do
        minimum_match 1
      end
      paginate page: params[:page], per_page: 30
    end
      @uploads = @search.results
      @query = params[:search]
  end

end
