class UserSessionsController < ApplicationController
  def new
    if current_user
      redirect_to tasks_path
    else
      @user = User.new
    end
  end

  def create
    if @user = login(user_session_params[:email], user_session_params[:password])
      redirect_back_or_to tasks_path, notice: I18n.t('message.login.success')
    else
      redirect_to login_path, notice: I18n.t('message.login.failed')
    end
  end

  def destroy
    logout
    redirect_to(:root, notice: I18n.t('message.logout.success'))
  end

  private

  def user_session_params
    params.require(:user).permit(:email, :password)
  end
end
