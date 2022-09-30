# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :find_board, only: %i[show destroy update]

      def index
        boards = Board.all
        presenter = BoardsPresenter.new(boards)
        if params[:include_columns].present? && params[:include_stories].present?
          render json: presenter.data, status: :ok
        else
          render json: presenter.as_json, status: :ok
        end
      end

      def show
        presenter = BoardPresenter.new(@board)
        render json: presenter.as_json, status: :ok
      end

      def create
        creator = BoardCreator.new
        board = creator.call(board_params)
        status = creator.succesful? ? :ok : :unprocessable_entity
        render json: { created: board }, status: status
      end

      def destroy
        destroyer = BoardDestroyer.new
        board = destroyer.call(board: @board)
        status = destroyer.succesful? ? :ok : :unprocessable_entity
        render json: { destroyed: board }, status: status
      end

      def update
        updater = BoardUpdater.new
        board = updater.call(board: @board, board_params: board_params)
        status = updater.succesful? ? :ok : :unprocessable_entity
        render json: { updated: board }, status: status
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
