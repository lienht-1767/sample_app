class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, :correct_user, only: %i(edit update)
  before_action :logged_in_user, only: %i(index)
  before_action :admin_user, only: %i(destroy)

  def show; end

  def index
    @users = User.activated.page(params[:page]).per(Settings.per_page_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_url
    else
      render :index
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:error] = t ".error_message"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".notification"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless @user == current_user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
