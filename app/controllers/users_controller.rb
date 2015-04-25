class UsersController < ApplicationController
  layout "no_container", only: :show

  def new
    @user = User.new
  end

  def index    
    @user_search = User.search do
      with :activated, true
      if params[:user_search].present?
        fulltext params[:user_search] do
          minimum_match 1
        end
      end
      order_by params[:sort_users], :desc if params[:sort_users].present?
      order_by :created_at, :desc
      paginate page: params[:page], per_page: 30
    end

    @users = @user_search.results
    @total_results = @user_search.total
    # create a deep clone of params for manipulation in view
    @user_query = Marshal.load(Marshal.dump(params))
    render 'users/index'
  end

  def show
    @user = User.find(params[:id])
    @uploads = UploadPolicy::Scope.new(current_user, @user.uploads).resolve.paginate(page: params[:page])
    authorize @user
    @user.update_stats
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
