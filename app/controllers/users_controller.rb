class UsersController < ApplicationController
  layout "user_profile", only: :show

  def new
    @user = User.new
  end

  def index
    @users = policy_scope(User).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @uploads = UploadPolicy::Scope.new(current_user, @user.uploads).resolve.paginate(page: params[:page])
    authorize @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:notice] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      if @user.cropping?
        @user.reprocess_avatar
      end
      flash[:success] = "Profile successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end

end
