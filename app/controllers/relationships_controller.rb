class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @upload = Upload.find(params[:liked_id])
    current_user.like(@upload)
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def destroy
    @upload = Relationship.find(params[:id]).liked
    current_user.unlike(@upload)
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end
end
