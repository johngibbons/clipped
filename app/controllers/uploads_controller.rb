class UploadsController < ApplicationController
  before_action :increment_views, only: :show
  layout "dropzone_uploader", only: :new

  def index
    @uploads = policy_scope(Upload)
  end

  def new
    @upload = current_user.uploads.new
  end

  def create
    @upload = current_user.uploads.new(upload_params)
    authorize @upload
    SaveImage.call(upload: @upload)
    if @upload.save
      render json: { message: "success", fileID: @upload.id }, :status => 200
      ProcessUploads.call(upload: @upload)
    else
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end
  end

  def show
    authorize @upload
  end

  def destroy
    @upload = Upload.find(params[:id])
    authorize @upload
    @upload.destroy
    flash[:success] = "Image successfully deleted"
    redirect_to request.referrer || current_user
  end

  private

    def upload_params
      params.require(:upload).permit(:image, :tags, :direct_upload_url)
    end

    def increment_views
      @upload = Upload.find_by(id: params[:id])
      @upload.views += 1
      @upload.save
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || login_path)
    end
end
