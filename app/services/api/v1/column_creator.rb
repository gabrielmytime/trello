# frozen_string_literal: true

module Api
  module V1
    class ColumnCreator
      def succesful?
        !!@succesful
      end

      def call(column_params:, board:)
        column = Column.new(column_params)
        column.board_id = board.id
        ActiveRecord::Base.transaction do
          @succesful = column.save
          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end
    end
  end
end
