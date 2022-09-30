# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :column

  # validations
  validates :name, presence: true

  acts_as_paranoid

  scope :by_position, -> { order(position: :asc) }
  scope :filter_by_status, -> (status) { where(status: status) }
  scope :filter_by_month, -> { where('due_date < ?', DateTime.now.next_month) }
  scope :filter_by_week, -> { where('due_date < ?', DateTime.parse('saturday') + 7) }
end
