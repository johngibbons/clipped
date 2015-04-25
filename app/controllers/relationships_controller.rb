class RelationshipsController < ApplicationController

  def create
    raise Pundit::NotAuthorizedError unless RelationshipPolicy.new(current_user).create?
    @upload = Upload.find(params[:favorited_id])
    current_user.favorite(@upload)
    @upload.user.update_stats
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def destroy
    raise Pundit::NotAuthorizedError unless RelationshipPolicy.new(current_user).destroy?
    @upload = Relationship.find(params[:id]).favorited
    current_user.unfavorite(@upload)
    @upload.user.update_stats
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end
end
