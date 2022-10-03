# frozen_string_literal: true

module Api
  module V1
    class BoardUpdater
      def succesful?
        !!@succesful
      end

      def call(board:, board_params:)
        ActiveRecord::Base.transaction do
          @succesful = board.update(board_params)

          raise ActiveRecord::Rollback unless succesful?
        end
        board
      end
    end
  end
end
