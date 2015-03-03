class RelationshipsController < ApplicationController

  def create
    raise Pundit::NotAuthorizedError unless RelationshipPolicy.new(current_user).create?
    @upload = Upload.find(params[:liked_id])
    current_user.like(@upload)
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def destroy
    raise Pundit::NotAuthorizedError unless RelationshipPolicy.new(current_user).destroy?
    @upload = Relationship.find(params[:id]).liked
    current_user.unlike(@upload)
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end
end
