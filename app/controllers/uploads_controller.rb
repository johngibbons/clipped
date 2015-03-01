class UploadsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :increment_views, only: :show
  before_action :approved_uploads, only: :index
  before_action :approved?, only: :show
  layout "dropzone_uploader", only: :new

  def index

  end

  def new
    @upload = current_user.uploads.new if logged_in?
  end

  def create
    @upload = current_user.uploads.new(upload_params)
    SaveImage.call(upload: @upload)
    if @upload.save
      render json: { message: "success", fileID: @upload.id }, :status => 200
      ProcessUploads.call(upload: @upload)
    else
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end
  end

  def show
    
  end

  def destroy
    @upload = current_user.uploads.find(params[:id])
    @upload.destroy
    flash[:success] = "Image successfully deleted"
    redirect_to request.referrer || current_user
  end

  private

    def upload_params
      params.require(:upload).permit(:image, :tags, :direct_upload_url)
    end

    def correct_user
      redirect_to current_user if !own_uploads?
    end

    def increment_views
      @upload = Upload.find_by(id: params[:id])
      @upload.views += 1
      @upload.save
    end
end
