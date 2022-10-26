# frozen_string_literal: true

module Api
  module V1
    class ColumnsPresenter
      attr_accessor :column

      def initialize(columns)
        @columns = columns
      end

      def columns
        columns = []
        @columns.each do |column|
          columns << {
            "id": column.id,
            "name": column.name,
            "board_id": column.board_id
          }
        end
        columns
      end

      def as_json(*)
        columns
      end
    end
  end
end
