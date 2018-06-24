class Task < ApplicationRecord
  acts_as_taggable_on :labels

  enum status: { todo: 1, doing: 2, done: 3 }
  enum priority: { low: 1, medium: 2, high: 3 }

  belongs_to :user, required: false
  belongs_to :owner, class_name: 'User'
  has_one_attached :file

  validates :title,    presence: true
  validates :status,   presence: true
  validates :priority, presence: true
  validate  :deadline_cannot_be_in_the_past, if: -> { deadline.present? }
  validate  :file_validation,  if: -> { file.attached? }

  scope :expired, -> { where('deadline <= ?', Time.zone.today) }
  scope :with_group, ->(group) { includes(user: :group).where(groups: { id: group&.id }) }

  def deadline_cannot_be_in_the_past
    errors.add(:deadline, 'は現在日付以降の日時を設定してください。') if deadline < Time.current.beginning_of_day
  end

  def self.search(search_attr)
    attr = search_attr.clone.to_h
    result = where('title LIKE ?', "%#{attr.delete(:title)}%")
    result = tagged_with(attr.delete(:label_list)) if attr[:label_list].present?
    result = result.where(attr) if attr.present?
    result
  end

  def editable?(target_user)
    if target_user.role.admin?
      true
    elsif target_user.group.present?
      user.group == target_user.group
    else
      user == target_user
    end
  end

  private

  def file_validation
    file_raise_error('のファイル容量が大きすぎます') if file.blob.byte_size > 10_000_000
    file_raise_error('は、画像以外はアップロード出来ません') unless file.blob.content_type.starts_with?('image/')
  end

  def file_raise_error(message)
    file.purge
    errors.add(:file, message)
    return
  end
end
