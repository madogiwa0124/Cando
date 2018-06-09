module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :only_admin_user

    USER_DISPLAY_PER_PAGE = 10

    def index
      @users = User.all.order(:id).page(params[:page]).per(USER_DISPLAY_PER_PAGE)
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
    end

    def edit
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)
      @user.group = Group.find(params[:user][:group])
      if @user.save
        redirect_to admin_user_path(@user), notice: message('user', 'create')
      else
        render :new
      end
    end

    def update
      @user = User.find(params[:id])
      @user.group = Group.find(params[:user][:group])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: message('user', 'update')
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_url, notice: message('user', 'destroy')
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role_id)
    end
  end
end
