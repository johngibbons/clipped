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
      flash[:success] = "Image successfully uploaded"
      redirect_to current_user
    else
      render "new"
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
