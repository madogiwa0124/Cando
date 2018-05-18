module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :only_admin_user

    USER_DISPLAY_PER_PAGE = 10

    def index
      @users = User.all.page(params[:page]).per(USER_DISPLAY_PER_PAGE)
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
      if @user.save
        redirect_to admin_user_path(@user), notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_url, notice: 'User was successfully destroyed.'
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
  end
end
