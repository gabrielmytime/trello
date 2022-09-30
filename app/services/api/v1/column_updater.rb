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

      def change_position(column:, to_position:, board:)
        ActiveRecord::Base.transaction do
          @succesful = @column_position_service.update_position(column: column, position: to_position, board: board)

          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end

      def change_board(board:, column:, to_position:, to_board:)
        new_board = Board.find(to_board.to_i)
        ActiveRecord::Base.transaction do
          @column_position_service.move_left(position: column.position, board: board)

          @column_position_service.empty_position(position: to_position, board: new_board)

          column.update({ board_id: to_board })

          @succesful = column.update({ position: to_position })

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
