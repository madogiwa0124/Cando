class ApplicationController < ActionController::Base
  def message(model, action)
    I18n.t("activerecord.models.#{model}") + I18n.t("message.common.#{action}")
  end

  def only_admin_user
    p '================================='
    p current_user.role
    p current_user.role.admin?
    p '================================='
    redirect_to root_path unless current_user.role.admin?
  end
end
