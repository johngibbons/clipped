class SearchController < ApplicationController

  def index
    #if no perspective, set to empty hash so solr skips
    params[:perspective_id] ||= []
    @search = Upload.search do
      with :approved, true
      facet :perspective_id
      with :perspective_id, params[:perspective_id] if params[:perspective_id].present?
      facet :category_id
      with :category_id, params[:category_id] if params[:category_id].present?
      fulltext params[:tag] if params[:tag].present?
      if params[:search].present?
        fulltext params[:search] do
          minimum_match 1
        end
      end
      paginate page: params[:page], per_page: 30
    end
      @uploads = @search.results
      @total_results = @search.total
      @query = (params[:search].to_s || "") + (params[:perspective].to_s || "") + (params[:tag].to_s || "")
      render layout: "no_container"
  end

end
