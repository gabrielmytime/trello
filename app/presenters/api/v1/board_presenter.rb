# frozen_string_literal: true

module Api
  module V1
    class BoardPresenter
      attr_accessor :board

      def initialize(board)
        @board = board
      end

      def as_json(*)
        {
          "id": @board.id,
          "name": @board.name
        }
      end
    end
  end
end
