class SearchController < ApplicationController

  def index
    #if no perspective, set to empty hash so solr skips
    params[:perspective_id] ||= []
    @search = Upload.search do
      with :approved, true
      with :perspective_id, params[:perspective_id]
      fulltext params[:tag]
      fulltext params[:search] do
        minimum_match 1
      end
      paginate page: params[:page], per_page: 30
    end
      @uploads = @search.results
      @total_results = @search.total
      @query = (params[:search].to_s || "") + (params[:perspective].to_s || "") + (params[:tag].to_s || "")
  end

end
