class Task < ApplicationRecord
  enum status: { todo: 1, doing: 2, done: 3 }
  enum priority: { low: 1, medium: 2, high: 3 }

  validates :title,    presence: true
  validates :status,   presence: true
  validates :priority, presence: true
  validate  :deadline_cannot_be_in_the_past, if: -> { deadline.present? }

  def deadline_cannot_be_in_the_past
    if deadline < Time.current
      errors.add(:deadline, "は現在時刻以降の日時を設定してください。")
    end
  end

  def self.search(search_attr)
    attr = search_attr.clone
    where("title LIKE '%#{ attr.delete(:title) }%'").where(attr)
  end
end
