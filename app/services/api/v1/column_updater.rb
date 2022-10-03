# frozen_string_literal: true

module Api
  module V1
    class ColumnUpdater
      def initialize(position_service: Api::V1::ColumnPositionService.new)
        @column_position_service = position_service
      end

      def succesful?
        !!@succesful
      end

      def change_position(board:, column:, to_position:)
        current_position = column.position
        ActiveRecord::Base.transaction do
          @succesful = @column_position_service.update_position(board: board, current_position: current_position, to_position: to_position)
          
          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end

      def change_board(board:, column:, to_board:, to_position:)
        current_position = column.position
        current_board = board.id
        ActiveRecord::Base.transaction do
          @succesful = @column_position_service.update_board_and_position(current_board: current_board, current_position: current_position,
            to_board: to_board, to_position: to_position)
            
          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end

      def call(column:, column_params:)
        ActiveRecord::Base.transaction do
          @succesful = column.update(column_params)

          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end
    end
  end
end
