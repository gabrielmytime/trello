# frozen_string_literal: true

module Api
  module V1
    class ColumnUpdater
      def succesful?
        !!@succesful
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
