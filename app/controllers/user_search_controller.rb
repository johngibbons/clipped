class UserSearchController < ApplicationController

  def index
    #if no perspective, set to empty hash so solr skips
    params[:perspective_id] ||= []
    params[:category_id] ||= []
    
    @user_search = User.search do
      with :activated, true
      if params[:user_search].present?
        fulltext params[:user_search] do
          minimum_match 1
        end
      end
      order_by params[:sort_users], :desc if params[:sort_users].present?
      paginate page: params[:page], per_page: 30
    end

    @users = @user_search.results
    @total_results = @user_search.total
    # create a deep clone of params for manipulation in view
    @user_query = Marshal.load(Marshal.dump(params))
  end

end
