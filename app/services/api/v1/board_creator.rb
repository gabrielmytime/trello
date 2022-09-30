# frozen_string_literal: true

module Api
  module V1
    class BoardCreator
      def succesful?
        !!@succesful
      end

      def call(board_params)
        board = Board.new(board_params)
        ActiveRecord::Base.transaction do
          @succesful = board.save

          raise ActiveRecord::Rollback unless succesful?
        end
        board
      end
    end
  end
end
