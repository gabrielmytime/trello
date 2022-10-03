# frozen_string_literal: true

#
# == Schema informations
#
# Table name: stories
#
# id                :integer      not null, primary key
# name              :string
# due_date          :datetime
# status            :string
# column_id         :integer
# position          :integer
# deleted_at        :datetime
# created_at        :datetime     not null
# updated_at        :datetime     not null
class Story < ApplicationRecord
  belongs_to :column

  # validations
  validates :name, presence: true

  acts_as_paranoid

  scope :by_position, -> { order(position: :asc) }
  scope :filter_by_status, ->(status) { where(status: status) }
  scope :filter_by_month, -> { where('due_date < ?', DateTime.now.next_month) }
  scope :filter_by_week, -> { where('due_date < ?', DateTime.parse('saturday') + 7) }
end
