# frozen_string_literal: true

module Api
  module V1
    class BoardDestroyer
      def succesful?
        !!@succesful
      end

      def call(board:)
        ActiveRecord::Base.transaction do
          @succesful = board.destroy

          raise ActiveRecord::Rollback unless succesful?
        end
        board
      end
    end
  end
end
