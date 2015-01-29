class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy, :download]

  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.all
  end

  def index_all_users
    @users = User.all
    @users.each do |user|
      @uploads = user.uploads.all
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    impressionist(@upload, "view")
  end

  # GET /uploads/new
  def new
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
    @upload = Upload.new
  end

  # GET /uploads/1/edit
  def edit
  end

  # @http_method XHR POST
  # @url /documents
  def create
    @upload = current_user.uploads.create(params[:upload])
  end


  # PATCH/PUT /uploads/1
  # PATCH/PUT /uploads/1.json
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Entourage item was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: 'Entourage item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
      params.require(:upload).permit(:tag_list, :perspective, :views, :downloads, :direct_upload_url)
    end
end
