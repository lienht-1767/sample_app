class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :verify_admin!, only: :destroy

  def show
    @microposts = @user.microposts.desc_created_at.page(params[:page])
      .per Settings.per_page_user
  end

  def index
    @users = User.activated.page(params[:page]).per Settings.per_page_user
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

  def following
    @title = t ".title"
    @user  = User.find_by id: params[:id]
    @users = @user.following.page(params[:page]).per Settings.per_page_user
    render "show_follow"
  end

  def followers
    @title = t ".title"
    @user  = User.find_by id: params[:id]
    @users = @user.followers.page(params[:page]).per Settings.per_page_user
    render "show_follow"
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

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless @user == current_user
  end

  def verify_admin!
    redirect_to(root_url) unless current_user.admin?
  end
end
