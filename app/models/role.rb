class Role < ActiveHash::Base
  include ActiveHash::Associations
  self.data = [
    {id: 1, code: :admin, name: '管理者' },
    {id: 2, dode: :staff, name: '担当者' }
  ]
end
