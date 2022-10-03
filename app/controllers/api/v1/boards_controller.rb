# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :find_board, only: %i[show destroy update]

      def index
        @boards = Board.all
        presenter = BoardsPresenter.new(@boards)
        if params[:include_columns].present? && params[:include_stories].present?
          render json: presenter.data_as_json
        else
          render json: presenter.as_json
        end
      end

      def show
        render json: BoardPresenter.new(@board).as_json
      end

      def create
        render json: BoardCreator.new.call(board_params: board_params)
      end

      def destroy
        render json: BoardDestroyer.new.call(board: @board)
      end

      def update
        render json: BoardUpdater.new.call(board: @board, board_params: board_params)
      end

      private

      def find_board
        @board = Board.find(params[:id])
      end

      def board_params
        params.permit(:name)
      end
    end
  end
end
