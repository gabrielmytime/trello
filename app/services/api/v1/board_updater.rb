# frozen_string_literal: true

module Api
  module V1
    class BoardUpdater
      def successful?
        !!@successful
      end

      def call(board:, board_params:)
        ActiveRecord::Base.transaction do
          @successful = board.update(board_params)

          raise ActiveRecord::Rollback unless successful?
        end
        board
      end
    end
  end
end
