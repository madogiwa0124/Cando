class UsersController < ApplicationController
  before_action :require_login

  TASK_DISPLAY_PER_PAGE = 8

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(TASK_DISPLAY_PER_PAGE)
  end

  def edit
    @user = User.find(params[:id])
    only_myself_redirect
  end

  def update
    @user = User.find(params[:id])
    only_myself_redirect
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def only_myself_redirect
    redirect_to user_path(@user) if @user != current_user
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
