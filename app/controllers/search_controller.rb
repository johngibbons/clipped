class SearchController < ApplicationController

  def index
    #if no perspective, set to empty hash so solr skips
    params[:perspective_id] ||= []
    params[:category_id] ||= []
    params[:search] = params[:tag] if params[:tag].present?
    
    @search = Upload.search do
      with :approved, true
      perspective_filter = with :perspective_id, params[:perspective_id] if params[:perspective_id].present?
      category_filter = with :category_id, params[:category_id] if params[:category_id].present?
      if params[:search].present?
        fulltext params[:search] do
          minimum_match 1
        end
      end
      order_by params[:sort_uploads], :desc if params[:sort_uploads].present?
      facet :perspective_id, limit: -1, exclude: perspective_filter
      facet :category_id, limit: -1, exclude: category_filter
      paginate page: params[:page], per_page: 30
    end

    @uploads = @search.results
    @total_results = @search.total
    # create a deep clone of params for manipulation in view
    @query = Marshal.load(Marshal.dump(params))
    
    respond_to do |format|
      format.html { render layout: "no_container" }
      format.js
    end
  end

end
