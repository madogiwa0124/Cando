class UserSessionsController < ApplicationController
  def new
    redirect_to tasks_path if current_user
    @user = User.new
  end

  def create
    @user = login(user_session_params[:email], user_session_params[:password])
    redirect_to login_path, notice: I18n.t('message.login.failed') unless @user
    redirect_back_or_to tasks_path, notice: I18n.t('message.login.success')
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
