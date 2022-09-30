# frozen_string_literal: true

module Api
  module V1
    class ColumnDestroyer
      def initialize(position_service: Api::V1::ColumnPositionService.new)
        @column_position_service = position_service
      end

      def succesful?
        !!@succesful
      end

      def call(column:, board:)
        ActiveRecord::Base.transaction do
          @succesful = column.destroy
          @column_position_service.move_left(board: board, position: column.position)
          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end
    end
  end
end
