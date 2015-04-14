class UploadSearch
  include ServiceHelper
  include Virtus.model

  attribute :params, Hash

  def call
    params = @params
    @search = Upload.search do
      with :approved, true
      with :perspective_id, params[:perspective_id] if params[:perspective_id].present?
      with :category_id, params[:category_id] if params[:category_id].present?
      fulltext params[:tag] if params[:tag].present?
      if params[:search].present?
        fulltext params[:search] do
          minimum_match 1
        end
      end
      facet :perspective_id, limit: -1
      facet :category_id, limit: -1
      paginate page: params[:page], per_page: 30
    end
  end

  def results
    @search.results
  end

end