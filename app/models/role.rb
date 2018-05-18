class Role < ActiveHash::Base
  include ActiveHash::Associations
  self.data = [
    {id: 1, code: :admin, name: I18n.t('enums.role.code.admin') },
    {id: 2, code: :staff, name: I18n.t('enums.role.code.staff') }
  ]

  def admin?
    code == :admin
  end
end
