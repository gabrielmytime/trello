# frozen_string_literal: true

module Api
  module V1
    class BoardDestroyer
      def successful?
        !!@successful
      end

      def call(board:)
        @board = board

        raise Api::V1::BoardError unless can_destroy_board?

        destroy_board
      end

      def can_destroy_board?
        @board.persisted?
      end

      def destroy_board
        @board.destroy

        @board
      end
    end
  end
end
