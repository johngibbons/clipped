class UploadModerationController < ApplicationController

  def update
    @upload = Upload.find(params[:id])
    authorize :upload_moderation, :update?
    if @upload.approved?
      current_user.disapprove(@upload)
      @upload.user.update_stats
    else
      current_user.approve(@upload)
      @upload.user.update_stats
      UploadModerationMailer.upload_approved_email(@upload).deliver_later
    end
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def index
    @uploads = Upload.where(approved: false).paginate(page: params[:page])
    authorize :upload_moderation, :index?
  end

end
