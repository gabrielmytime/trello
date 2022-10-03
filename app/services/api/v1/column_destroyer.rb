# frozen_string_literal: true

module Api
  module V1
    class ColumnDestroyer
      def succesful?
        !!@succesful
      end

      def call(column:, board:)
        ActiveRecord::Base.transaction do
          @succesful = column.destroy
          raise ActiveRecord::Rollback unless succesful?
        end
        column
      end
    end
  end
end
