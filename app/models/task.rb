class Task < ApplicationRecord
  acts_as_taggable_on :labels

  enum status: { todo: 1, doing: 2, done: 3 }
  enum priority: { low: 1, medium: 2, high: 3 }

  belongs_to :user, required: false
  belongs_to :owner, class_name: 'User'

  validates :title,    presence: true
  validates :status,   presence: true
  validates :priority, presence: true
  validate  :deadline_cannot_be_in_the_past, if: -> { deadline.present? }

  scope :expired, -> { where('deadline <= ?', Time.zone.today) }
  scope :with_group, -> (group) { includes(user: :group).where(groups: { id: group&.id }) }

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
end
