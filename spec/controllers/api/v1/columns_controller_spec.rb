# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::ColumnsController', type: :request do
  let(:board) { create(:board, name: 'board') }
  let(:column) { create(:column, name: 'column', board_id: board.id) }

  describe '#index' do
    it 'renders all columns that belong to the board' do
      get api_v1_board_columns_path(board_id: board.id)
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'renders column' do
      get api_v1_board_column_path(board_id: board.id, id: column.id)
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(column.id)
    end
  end

  describe '#create' do
    it 'creates a column' do
      post api_v1_board_columns_path(board_id: board.id), params: { name: 'test column' }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['created']['board_id']).to eq(board.id)
      expect(parsed_response['created']['name']).to eq('test column')
    end
  end

  describe '#update' do
    it 'updates column' do
      put api_v1_board_column_path(board_id: board.id, id: column.id),
          params: { column: column, name: 'column updated' }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['updated']['name']).to eq('column updated')
    end
  end

  describe '#destroy' do
    it 'deletes column' do
      delete api_v1_board_column_path(board_id: board.id, id: column.id)
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['destroyed']['deleted_at']).not_to be(nil)
    end

    it 'should NOT let me delete column (404)' do
      delete api_v1_board_column_path(board_id: board.id, id: 123_123)
      expect(response).to have_http_status(404)
    end
  end
end
