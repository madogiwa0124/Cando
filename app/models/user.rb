class User < ApplicationRecord
  authenticates_with_sorcery!
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :tasks
  belongs_to_active_hash :role

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, uniqueness: true, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, length: { maximum: 255 }, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
