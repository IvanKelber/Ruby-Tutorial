class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update, :destroy]
  before_action :correct_user, only: [:edit,:update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page],per_page:10)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page],per_page:10)
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User: \"#{@user.name}\" has been deleted!"
    redirect_to users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if !@user.authenticate(user_params[:current_password])
      @user.errors.add(:base,:blank,message: "Current password is incorrect")
      render 'edit'
      return
    end
    if @user.update_attributes(user_params)
      flash[:success] = "Account information updated"
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :current_password, :password,
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user? @user
    end

end
