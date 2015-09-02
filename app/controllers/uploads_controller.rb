class UploadsController < ApplicationController

  def new
    @upload = current_user.uploads.new
    render layout: "dropzone_uploader"
  end

  def create
    @upload = current_user.uploads.new(upload_params)
    authorize @upload
    SaveImage.call(upload: @upload)
    if @upload.save
      @upload.user.update_stats
      flash[:notice] = "Please allow for a day or two before your uploads are approved."
      render json: @upload
      ProcessUploads.call(upload: @upload)
    else
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end
  end

  def update
    @upload = Upload.find(params[:id])
    authorize @upload
    respond_to do |format|
      if @upload.update(upload_params)
        format.js
        format.json { render json: @upload }
      else
        flash.now[:error] = "There was an issue updating your upload"
        format.html { render "show" }
      end
    end
  end

  def show
    @upload = Upload.find(params[:id])
    authorize @upload
  end

  def destroy
    @upload = Upload.find(params[:id])
    authorize @upload
    @upload.destroy
    @upload.user.update_stats
    respond_to do |format|
      format.html {
        flash[:success] = "Image successfully deleted"
        redirect_to current_user
      }
      format.js
    end
  end

  def download
     @upload = Upload.find(params[:id])
     @upload.downloads += 1
     @upload.save!
     @upload.user.update_stats
     redirect_to @upload.download_url
  end

  private

    def upload_params
      params.require(:upload).permit(:image, :direct_upload_url, :tag_list, :perspective, :category, :dz_thumb)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || login_path)
    end
end
