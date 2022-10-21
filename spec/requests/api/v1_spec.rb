# frozen_string_literal: true

require 'swagger_helper'

describe 'TRELLO API VERSION 1', swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/boards' do
    get 'Retrieve the boards' do
      tags 'Boards'
      consumes 'application/json'
      response '200', 'boards retrieved' do
        let(:board) { { name: 'foo' } }
        run_test!
      end
    end

    post 'Creates a board' do
      tags 'Boards'
      consumes 'application/json'
      parameter name: :board, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'board created' do
        let(:board) { { name: 'foo' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:board) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{id}' do
    get 'Retrieves a board' do
      tags 'Boards'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'board found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]

        let(:id) { Board.create(name: 'foo').id }
        run_test!
      end

      response '404', 'board not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end
    end

    put 'Updates a board' do
      tags 'Boards'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :board, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'board updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]

        let(:id) { Board.create(name: 'foo').id }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]

        let(:id) { Board.create(name: '').id }
        run_test!
      end
    end

    delete 'Deletes a board' do
      tags 'Boards'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'board deleted' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]

        let(:id) { Board.create(name: 'foo').id }
        run_test!
      end

      response '404', 'board not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns' do
    get 'Retrieve the columns of a board' do
      tags 'Columns'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      response '200', 'columns retrieved' do
        let(:board) { { name: 'foc' } }
        let(:column) { { name: 'foo', board_id: board.id } }
        run_test!
      end
    end

    post 'Creates a column' do
      tags 'Columns'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'column created' do
        let(:column) { { name: 'foo' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:column) { { name: '' } }
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

      response '200', 'column found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]
        let(:board) { Board.create(name: 'foo') }
        let(:id) { Column.create(name: 'foo').id }
        run_test!
      end

      response '404', 'column not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end
    end

    put 'Updates a column' do
      tags 'Columns'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :column, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'column updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]
        let(:board) { Board.create(name: 'foo') }
        let(:id) { Column.create(name: 'foo').id }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]
        let(:board) { Board.create(name: 'foo') }
        let(:id) { Column.create(name: '').id }
        run_test!
      end
    end

    delete 'Deletes a column' do
      tags 'Columns'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'column deleted' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]
        let(:board) { Board.create(name: 'foo') }
        let(:id) { Column.create(name: 'foo').id }
        run_test!
      end

      response '404', 'column not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/boards/{board_id}/columns/{column_id}/stories' do
    get 'Retrieve the stories of a column' do
      tags 'Stories'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      response '200', 'columns retrieved' do
        let(:board) { { name: 'board' } }
        let(:column) { { name: 'column', board_id: board.id } }
        let(:story) { { name: 'foo', column_id: column.id } }
        run_test!
      end
    end

    post 'Creates a story' do
      tags 'Stories'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :story, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          status: { type: :string },
          due_date: { type: :datetime }
        },
        required: ['name' 'status' 'due_date']
      }

      response '201', 'story created' do
        let(:story) { { name: 'foo', status: 'a' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:story) { { name: '' } }
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

      response '200', 'story found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 status: { type: :string },
                 due_date: { type: :datetime }
               },
               required: %w[id name due_date status]
        let(:board) { Board.create(name: 'board') }
        let(:column) { Column.create(name: 'column', board_id: board.id) }
        let(:id) { Story.create(name: 'foo').id }
        run_test!
      end

      response '404', 'story not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end
    end

    put 'Updates a story' do
      tags 'Stories'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :story, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'story updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 status: { type: :string },
                 due_date: { type: :datetime }
               },
               required: %w[id name due_date status]
        let(:board) { Board.create(name: 'board') }
        let(:column) { Column.create(name: 'column', board_id: board.id) }
        let(:id) { Story.create(name: 'foo').id }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 status: { type: :string },
                 due_date: { type: :datetime }
               },
               required: %w[id name due_date status]
        let(:board) { Board.create(name: 'board') }
        let(:column) { Column.create(name: 'column', board_id: board.id) }
        let(:id) { Story.create(name: '').id }
        run_test!
      end
    end

    delete 'Deletes a story' do
      tags 'Stories'
      consumes 'application/json'
      parameter name: :board_id, in: :path, type: :string
      parameter name: :column_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'story deleted' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 status: { type: :string },
                 due_date: { type: :datetime }
               },
               required: %w[id name due_date status]
        let(:board) { Board.create(name: 'board') }
        let(:column) { Column.create(name: 'column', board_id: board.id) }
        let(:id) { Story.create(name: 'foo').id }
        run_test!
      end

      response '404', 'story not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
