class ApplicationController < ActionController::Base
  def message(model, action)
    I18n.t("activerecord.models.#{model}") + I18n.t("message.common.#{action}")
  end
end
