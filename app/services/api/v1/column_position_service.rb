# frozen_string_literal: true

module Api
  module V1
    class ColumnPositionService
      # we move all the columns in a board
      # if our position > column.position then we increment column.position
      def move_right(position:, board:)
        board.columns.each do |column|
          column.update({ position: column.position + 1 }) if column.position <= position
        end
      end

      # we move all the columns in a board
      # if our position < column.position then we decrease column.position
      def move_left(position:, board:)
        board.columns.each do |column|
          column.update({ position: column.position - 1 }) if column.position > position
        end
      end

      # here we empty our position for the new insert
      # if column. position >= our position then we increment the column.position
      def empty_position(position:, board:)
        board.columns.each do |column|
          column.update({ position: column.position + 1 }) if column.position >= position
        end
      end

      # if our position > column.position we move right
      # otherwise we move up
      def update_position(column:, position:, board:)
        if column.position > position
          move_right(position: column.position, board: board)
        else
          move_left(position: column.position, board: board)
        end
        column.update({ position: position })
      end
    end
  end
end
