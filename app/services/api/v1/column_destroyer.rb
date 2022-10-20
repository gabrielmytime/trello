# frozen_string_literal: true

module Api
  module V1
    class ColumnDestroyer
      def successful?
        !!@successful
      end

      def call(column:, board:)
        ActiveRecord::Base.transaction do
          @successful = column.destroy
          raise ActiveRecord::Rollback unless successful?
        end
        column
      end
    end
  end
end
