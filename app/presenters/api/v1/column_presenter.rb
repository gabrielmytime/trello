# frozen_string_literal: true

module Api
  module V1
    class ColumnPresenter
      attr_accessor :column

      def initialize(column)
        @column = column
      end

      def as_json(*)
        {
          "id": @column.id,
          "name": @column.name,
          "board_id": @column.board_id
        }
      end
    end
  end
end
