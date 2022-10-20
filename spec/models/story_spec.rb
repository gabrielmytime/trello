# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:board) { create(:board, name: 'board') }
  let(:column) { create(:column, name: 'column', board_id: board.id) }
  let(:story) { create(:story, name: 'story', column_id: column.id) }
  describe '#destroy' do
    it 'updates deleted_at' do
      expect(column.deleted_at).to be(nil)
      column.destroy
      expect(column.deleted_at).not_to be(nil)
    end
  end
  describe 'a' do
    before do
    def a(adva)
      !!adva
    end
    end
    it 'aa' do
      value1 = 'aaaaa'
      value2 = true
      value3 = 4
      value4 = false
      value5 = ''
      value6 = nil
      pp 'aaaaa',a(value1)
      pp 'true',a(value2)
      pp '4',a(value3)
      pp 'false',a(value4)
      pp 'empty',a(value5)
      pp 'nil',a(value6)
      pp 'story', a(story.save)
      expect(true).to be_truthy
    end
  end
end
