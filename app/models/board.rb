# frozen_string_literal: true

class Board < ApplicationRecord
  has_many :columns, dependent: :destroy

  # validations
  validates :name, presence: true

  acts_as_paranoid

  def stories
    stories = []
    columns.each { |column| stories += column.stories }
    stories
  end
end
