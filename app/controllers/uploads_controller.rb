class UploadsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @uploads = Upload.all
  end

  def new
    @upload = current_user.uploads.build if logged_in?
  end

  def create
    @upload = current_user.uploads.build(upload_params)
    if @upload.save
      render json: { message: "success", fileID: @upload.id }, :status => 200
    else
      render json: { error: @image.errors.join(',')}, :status => 400
    end
  end

  def show

  end

  def destroy
    @upload.destroy
    flash[:success] = "Image successfully deleted"
    redirect_to request.referrer || current_user
  end

  private

    def upload_params
      params.require(:upload).permit(:image, :tags)
    end

    def correct_user
      @upload = current_user.uploads.find_by(id: params[:id])
      redirect_to current_user if @upload.nil?
    end
end
