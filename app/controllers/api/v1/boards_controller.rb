# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :find_board, only: %i[show destroy update]

      def index
        @boards = Board.all
        presenter = Api::V1::BoardsPresenter.new(@boards)
        if params[:include_columns].present? && params[:include_stories].present?
          render :json => { data: presenter.data_as_json } 
        else
          render :json => { boards: presenter.as_json } 
        end
      end

      def show
        presenter = Api::V1::BoardPresenter.new(@board)
        render :json => { board: presenter.as_json }
      end

      def create
        creator = Api::V1::BoardCreator.new
        board = creator.call(board_params: board_params)
        status = creator.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::BoardPresenter.new(board)
        render :json => { board: presenter.as_json }, status: status
      end

      def destroy
        destroyer = Api::V1::BoardDestroyer.new
        destroyer.call(@board)
        status = creator.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::BoardPresenter.new(@board)
        render :json => { board: presenter.as_json }, status: status 
      end

      def update
        updater = Api::V1::BoardUpdater.new
        updater.call(board: @board, board_params: board_params)
        status = updater.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::BoardPresenter.new(@board)
        render :json => { board: presenter.as_json }, status: status 
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
