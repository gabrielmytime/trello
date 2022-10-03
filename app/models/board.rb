# frozen_string_literal: true
# 
# == Schema informations
#
# Table name: boards
#
# id                :integer      not null, primary key
# name              :string
# deleted_at        :datetime
# created_at        :datetime     not null
# updated_at        :datetime     not null
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
