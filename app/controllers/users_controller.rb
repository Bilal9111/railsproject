class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :delete]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :is_activated,  only: :show





  def new
  	@user = User.new
  end
  def show
  	@user = User.find(params[:id])
    @count = @user.micropost.count
    @microposts = @user.micropost.paginate(page: params[:page])
  	#debugger
  end
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user

    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  private
    #This method helps to make sure that only the activated users can be SHOWN
    def is_activated
      @user = User.find(params[:id])
      if @user
        #if is activated then dont do anything
      else
        flash[:failure] = "The user requested is not activated.If this is your account, then please check your email. :)"
        redirect_to root_url
       end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end