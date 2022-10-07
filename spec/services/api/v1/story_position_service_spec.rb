# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::StoryPositionService' do
  let(:board) { create(:board, name:Faker::Name.name) }
  let(:column) { create(:column, name:Faker::Name.name, board_id: board.id) }
  let(:story1) { create(:story, name:Faker::Name.name, column_id: column.id, position: 1) }
  let(:story2) { create(:story, name:Faker::Name.name, column_id: column.id, position: 2) }

  describe "#update_position" do
    it "should move my story to position 1" do
      expect(story2.position).to eq(2)
      Api::V1::StoryPositionService.new.change_position(column: column, story: story2, to_position: 1)
      expect(story2.position).to eq(1)
    end
  end

end