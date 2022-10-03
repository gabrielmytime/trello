# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BoardsController', type: :request do
  let(:board) { create(:board, name: 'test board') }

  describe '#index' do
    it 'renders all the boards' do
      get api_v1_boards_path
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'renders the given board' do
      get api_v1_board_path(id: board.id)
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(board.id)
    end
  end

  describe '#create' do
    it 'creates a board' do
      post api_v1_boards_path, params: { name: 'test board' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['name']).to eq('test board')
    end
  end

  describe '#update' do
    it 'updates board' do
      put api_v1_board_path(id: board.id), params: { board: board, name: 'Name board updated' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['name']).to eq('Name board updated')
    end
  end

  describe '#destroy' do
    it 'deletes board' do
      delete api_v1_board_path(id: board.id), params: { board: board }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['deleted_at']).not_to be(nil)
    end

    it 'should NOT let me delete a board (404)' do
      delete api_v1_board_path(id: 123_123), params: { board: board }
      expect(response).to have_http_status(404)
    end
  end
end
