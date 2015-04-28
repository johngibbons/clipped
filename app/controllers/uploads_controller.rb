class UploadsController < ApplicationController
  before_action :increment_views, only: :show

  def index
    @viewable_uploads = policy_scope(Upload).paginate(page: params[:page])
    @uploads = @viewable_uploads
    render layout: "no_container"
  end

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
      render json: { id: @upload.id,  }, :status => 200
      ProcessUploads.call(upload: @upload)
    else
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end
  end

  def update
    @upload = Upload.find(params[:id])
    authorize @upload
    if @upload.update(upload_params)
      respond_to do |format|
        format.js
        format.json { render json: @upload }
      end
    else
      flash.now[:error] = "There was an issue updating your upload"
      render "show"
    end
  end

  def show
    authorize @upload
  end

  def destroy
    @upload = Upload.find(params[:id])
    authorize @upload
    @upload.destroy
    @upload.user.update_stats
    flash[:success] = "Image successfully deleted"
    respond_to do |format|
      format.html { redirect_to current_user }
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
      params.require(:upload).permit(:image, :direct_upload_url, :tag_list, :perspective, :category)
    end

    def increment_views
      @upload = Upload.find_by(id: params[:id])
      @upload.views += 1
      @upload.save
      @upload.user.update_stats
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || login_path)
    end
end
