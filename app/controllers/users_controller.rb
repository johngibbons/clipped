class UsersController < ApplicationController
  layout "no_container", only: :show
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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

    respond_to do |format|
      format.html { render 'users/index' }
      format.js
    end
  end

  def show
    @uploads = UploadPolicy::Scope.new(current_user, @user.uploads).resolve.paginate(page: params[:page])
    authorize @user

    if params[:filter_uploads] == "unapproved"
      @uploads = @uploads.where(approved: false)
    elsif params[:filter_uploads] == "favorites"
      @uploads = @user.favoriting.paginate(page: params[:page])
    else
      @uploads = @uploads.where(approved: true)
    end

    if params[:filter_uploads] && !params[:page]
      render "filter.js.erb"
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.delay.avatar_from_url(User::DEFAULT_AVATAR_URL)
      @user.send_activation_email
      flash[:notice] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update_attributes(user_params)
        if params[:user][:crop_h]
          @user.reprocess_avatar
        end
        format.js {}
        format.html {
          if params[:user][:crop_h]
            flash[:success] = "Profile image successfully updated"
            redirect_to(request.referrer || @user)
          else
            flash[:success] = "Profile successfully updated"
            redirect_to @user
          end
        }
      else
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    authorize @user
    log_out if logged_in?
    @user.destroy
    flash[:success] = "User deleted successfully"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:username, :name, :email, :password, :password_confirmation, :avatar, :crop_x, :crop_y, :crop_w, :crop_h, :avatar_original_width)
    end

    def set_user
      @user = User.find_by_username(params[:id])
    end

end
