# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create(:board, name: 'test') }
  describe '#destroy' do
    it 'updates deleted_at' do
      expect(board.deleted_at).to be(nil)
      board.destroy
      expect(board.deleted_at).not_to be(nil)
    end
  end
end
