class User < ApplicationRecord
  authenticates_with_sorcery!
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :tasks
  has_many :owner_tasks, class_name: 'Task', foreign_key: :owner_id, inverse_of: :owner
  has_one :user_group
  has_one :group, through: :user_group
  belongs_to_active_hash :role

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, uniqueness: true, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, length: { maximum: 255 }, presence: true
  validates :role, presence: true, inclusion: { in: Role.all }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
