class UploadModerationController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def update
    @upload = Upload.find(params[:id])
    if @upload.approved?
      current_user.disapprove(@upload)
    else
      current_user.approve(@upload)
    end
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def index
    @uploads = Upload.where(approved: false).paginate(page: params[:page])
  end

end
