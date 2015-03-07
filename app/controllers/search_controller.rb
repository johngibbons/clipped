class SearchController < ApplicationController

  def index
    @search = Upload.search do
      fulltext params[:search] do
        minimum_match 1
      end
      with :approved, true
      paginate page: params[:page], per_page: 30
    end
      @uploads = @search.results
      @query = params[:search]
  end

end
