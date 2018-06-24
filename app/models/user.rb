class User < ApplicationRecord
  authenticates_with_sorcery!
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :tasks
  has_many :owner_tasks, class_name: 'Task', foreign_key: :owner_id, inverse_of: :owner
  has_one :user_group
  has_one :group, through: :user_group
  belongs_to_active_hash :role
  has_one_attached :avatar

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, uniqueness: true, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, length: { maximum: 255 }, presence: true
  validates :role, presence: true, inclusion: { in: Role.all }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
<<<<<<< Updated upstream
  validate  :file_validation,  if: -> { avatar.attached? }
=======
  validate  :file_validation, if: -> { avatar.attached? }
>>>>>>> Stashed changes

  private

  def file_validation
<<<<<<< Updated upstream
    file_raise_error('のファイル容量が大きすぎます') if avatar.blob.byte_size > 10_000_000
    file_raise_error('は、画像以外アップロード出来ません') unless avatar.blob.content_type.starts_with?('image/')
=======
    if avatar.blob.byte_size > 1_000_000
      file_raise_error('のファイル容量が大きすぎます')
    elsif !avatar.blob.content_type.starts_with?('image/')
      file_raise_error('は、画像以外はアップロード出来ません')
    end
>>>>>>> Stashed changes
  end

  def file_raise_error(message)
    avatar.purge
    errors.add(:avatar, message)
<<<<<<< Updated upstream
    return
=======
>>>>>>> Stashed changes
  end
end
