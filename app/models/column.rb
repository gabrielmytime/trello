# frozen_string_literal: true
# 
# == Schema informations
#
# Table name: columns
#
# id                :integer      not null, primary key
# name              :string
# board_id          :integer
# position          :integer
# deleted_at        :datetime
# created_at        :datetime     not null
# updated_at        :datetime     not null
class Column < ApplicationRecord
  belongs_to :board
  has_many :stories, dependent: :destroy

  acts_as_paranoid

  scope :by_position, -> { order(position: :asc) }
  # validations
  validates :name, presence: true
end
