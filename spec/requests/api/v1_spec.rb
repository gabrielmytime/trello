# frozen_string_literal: true

require 'swagger_helper'

describe 'TRELLO API VERSION 1', swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/boards' do
    get 'Retrieve the boards' do
      tags 'Boards'
      produces 'application/json'
      response(200, 'boards retrieved') do
        run_test! do |response| 
          data = JSON.parse(response.body)
          expect(data["boards"].count).to eq(4)
        end
      end
    end

    post 'Creates a board' do
      tags 'Boards'
      consumes "application/json"
      produces "application/json"
      parameter name: :board_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'successful') do
        let(:board_params) do { name: "foo" } end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["board"]["name"]).to eq("foo")
        end
      end

      response(422, 'invalid request') do
        let(:board_params) do { name: "" } end
        run_test!
      end
    end
  end

  path '/api/v1/boards/{id}' do
    get 'Retrieve a board' do
      tags 'Boards'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      let(:board) { create(:board, name: 'foo') }

      response(200, 'board found') do
        let(:id) { board.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["board"]["id"]).to eq(board.id)
          expect(data["board"]["name"]).to eq(board.name)
        end
      end
    end

    put 'Updates a board' do
      tags 'Boards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :update_params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'board updated') do
        let(:update_params) { { name: 'update' } }
        let(:id) { create(:board, name: 'foo').id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["board"]["name"]).to eq('update')
        end
      end

      response(422, 'invalid request') do
        let(:update_params) { { name: '' } }
        let(:id) { create(:board, name: 'foo').id }
        run_test!
      end
    end

    delete 'Deletes a board' do
      tags 'Boards'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      let(:board) { create(:board, name: 'foo') }

      response(200, 'board deleted') do
        let(:id) { board.id }
        run_test!
      end

      response(404, 'board not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns' do
    get 'Retrieves the columns of a board' do
      tags 'Columns'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'col', board: board) }

      response(200, 'columns retrieved') do
        let(:board_id) { board.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["columns"].last["name"]).to eq('col')
        end
      end

      response(404, 'not found') do
        let(:board_id) { 'invalid' }
        run_test!
      end
    end

    post 'Creates a column' do
      tags 'Columns'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ['name']
      }
      let!(:board) { create(:board, name: 'foo') }
      
      response(200, 'column created') do
        let(:board_id) { board.id }
        let(:column_params) do { name: "foo", board_id: board.id } end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["column"]["name"]).to eq('foo')
          expect(data["column"]["board_id"]).to eq(board.id)
        end
      end

      response(422, 'invalid request') do
        let(:board_id) { board.id }
        let(:column_params) do { name: "", board_id: board.id } end
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns/{id}' do
    get 'Retrieves a column' do
      tags 'Columns'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      let(:board) { create(:board, name: 'foo') }
      let(:column) { create(:column, name: 'foo', board_id: board.id) }

      response(200, 'column found') do
        let(:board_id) { board.id }
        let(:id) { column.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["column"]["name"]).to eq('foo')
          expect(data["column"]["board_id"]).to eq(board.id)
        end
      end

      response(404, 'not found') do
        let(:board_id) { board.id }
        let(:id) { 'invalid' }
        run_test! 
      end
    end

    put 'Updates a column' do
      tags 'Columns'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :update_column_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ['name']
      }
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }

      response(200, 'column updated') do
        let(:board_id) { board.id }
        let(:id) { column.id }
        let(:update_column_params) { { name: 'update' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["column"]["name"]).to eq('update')
          expect(data["column"]["board_id"]).to eq(board.id)
        end
      end

      response(422, 'invalid request') do
        let(:board_id) { board.id }
        let(:id) { column.id }
        let(:update_column_params) { { name: '' } }
        run_test!
      end
    end

    delete 'Deletes a column' do
      tags 'Columns'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }

      response(200, 'column deleted') do
        let(:board_id) { board.id }
        let(:id) { column.id }
        run_test!
      end

      response(404, 'column not found') do
        let(:board_id) { board.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns/{column_id}/stories' do
    get 'Retrieves stories' do
      tags 'Stories'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }
      let!(:story) { create(:story, name: 'foo', column_id: column.id) }

      response(200, 'stories retrieved') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["stories"].last["name"]).to eq('foo')
        end
      end

      response(404, 'not found') do
        let(:board_id) { board.id }
        let(:column_id) { 'invalid' }
        run_test!
      end
    end

    post 'Creates a story' do
      tags 'Stories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :story_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ['name']
      }
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }

      response(200, 'story created') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:story_params) { { name:'story' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["story"]["name"]).to eq('story')
          expect(data["story"]["column_id"]).to eq(column.id)
        end
      end

      response(422, 'invalid request') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:story_params) { { name:'' } }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns/{column_id}/stories/{id}' do
    get 'Retrieves a story' do
      tags 'Stories'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      let(:board) { create(:board, name: 'foo') }
      let(:column) { create(:column, name: 'foo', board_id: board.id) }
      let(:story) { create(:story, name: 'foo', column_id: column.id) }

      response(200, 'story found') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { story.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["story"]["name"]).to eq('foo')
          expect(data["story"]["column_id"]).to eq(column.id)
        end
      end

      response(404, 'not found') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { 'invalid' }
        run_test! 
      end
    end

    put 'Updates story' do
      tags 'Stories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :update_story_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ['name']
      }
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }
      let!(:story) { create(:story, name: 'foo', column_id: column.id) }

      response(200, 'story created') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { story.id }
        let(:update_story_params) { { name:'update' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["story"]["name"]).to eq('update')
          expect(data["story"]["column_id"]).to eq(column.id)
        end
      end

      response(422, 'invalid request') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { story.id }
        let(:update_story_params) { { name:'' } }
        run_test!
      end
    end

    delete 'Deletes a story' do
      tags 'Stories'
      produces 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      let!(:board) { create(:board, name: 'foo') }
      let!(:column) { create(:column, name: 'foo', board_id: board.id) }
      let!(:story) { create(:story, name: 'foo', column_id: column.id) }

      response(200, 'column deleted') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { story.id }
        run_test!
      end

      response(404, 'column not found') do
        let(:board_id) { board.id }
        let(:column_id) { column.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
