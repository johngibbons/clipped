class SearchController < ApplicationController

  def index
    #if no perspective, set to empty hash so solr skips
    params[:perspective] ||= []
    @search = Upload.search do
      with :approved, true
      with :perspective, params[:perspective]
      fulltext params[:tag]
      fulltext params[:search] do
        minimum_match 1
      end
      paginate page: params[:page], per_page: 30
    end
      @uploads = @search.results
      @query = (params[:search].to_s || "") + (params[:perspective].to_a.join(",")) + (params[:tag].to_s || "")
  end

end
