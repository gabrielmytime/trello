# frozen_string_literal: true

class Column < ApplicationRecord
  belongs_to :board
  has_many :stories, dependent: :destroy

  acts_as_paranoid

  scope :by_position, -> { order(position: :asc) }
  # validations
  validates :name, presence: true
end
