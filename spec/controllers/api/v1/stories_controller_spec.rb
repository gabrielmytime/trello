# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::StoriesController', type: :request do
  let(:board) { create(:board, name: 'board') }
  let(:column) { create(:column, name: 'column', board_id: board.id) }
  let(:story) { create(:story, name: 'story', column_id: column.id, position: 1) }
  let(:story2) { create(:story, name: 'story2', column_id: column.id, position: 2)}

  describe '#index' do
    it 'renders all stories that belong to the column' do
      get api_v1_board_column_stories_path(board_id: board.id, column_id: column.id)
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'renders story' do
      get api_v1_board_column_story_path(board_id: board.id, column_id: column.id, id: story.id)
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(story.id)
    end
  end

  describe '#create' do
    it 'creates a story' do
      post api_v1_board_column_stories_path(board_id: board.id, column_id: column.id), params: { name: 'test story' }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['column_id']).to eq(column.id)
      expect(parsed_response['name']).to eq('test story')
    end
  end

  describe '#update' do
    it 'updates story' do
      put api_v1_board_column_story_path(board_id: board.id, column_id: column.id, id: story.id),
          params: { story: story, name: 'story updated' }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq('story updated')
    end
  end

  describe '#destroy' do
    it 'deletes story' do
      delete api_v1_board_column_story_path(board_id: board.id, column_id: column.id, id: story.id)
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['deleted_at']).not_to be(nil)
    end

    it 'should NOT let me delete story (404)' do
      delete api_v1_board_column_story_path(board_id: board.id, column_id: column.id, id: 123_123)
      expect(response).to have_http_status(404)
    end
  end
end
