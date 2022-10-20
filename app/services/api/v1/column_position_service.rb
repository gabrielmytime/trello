# frozen_string_literal: true

module Api
  module V1
    class ColumnPositionService
      def successful?
        !!@successful
      end

      def change_position(board:, column:, to_position:)
        current_position = column.position
        ActiveRecord::Base.transaction do
          @successful = update_position(board: board, current_position: current_position,
                                                                to_position: to_position)

          raise ActiveRecord::Rollback unless successful?
        end
        column
      end

      def change_board(board:, column:, to_board:, to_position:)
        current_position = column.position
        current_board = board.id
        ActiveRecord::Base.transaction do
          @successful = update_board_and_position(current_board: current_board, current_position: current_position,
                                                                          to_board: to_board, to_position: to_position)

          raise ActiveRecord::Rollback unless successful?
        end
        column
      end

      private
      def update_position(board:, current_position:, to_position:)
        board.columns.update_all("position=case
          when position = #{current_position} then #{to_position}
          when position >= #{to_position} and #{to_position} < #{current_position} then position + 1
          when position <= #{to_position} and #{to_position} > #{current_position} then position - 1
        else position end")
      end

      def update_board_and_position(current_board:, current_position:, to_board:, to_position:)
        Column.where(board_id: [current_board, to_board]).update_all("position = case
            when position >= #{to_position} and board_id = #{to_board} then position + 1
            when position = #{current_position} and board_id = #{current_board} then #{to_position}
            else position
          end
          ,board_id = case
            when position = #{current_position} and board_id = #{current_board} then #{to_board}
            else board_id
          end
          ,position = case
            when position > #{current_position} and board_id = #{current_board} then position - 1
            else position
          end")
      end
    end
  end
end
