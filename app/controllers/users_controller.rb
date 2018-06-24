class UsersController < ApplicationController
  before_action :require_login

  TASK_DISPLAY_PER_PAGE = 8

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(TASK_DISPLAY_PER_PAGE)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.avatar.attach(params[:user][:avatar])
    if @user.update(user_params)
      redirect_to @user, notice: message('user', 'update')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :avatar)
  end
end
