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
end
