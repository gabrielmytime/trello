# frozen_string_literal: true

module Api
  module V1
    class ColumnsController < ApplicationController
      before_action :find_board
      before_action :find_column, only: %i[show update destroy]

      def index
        columns = @board.columns
        presenter = ColumnsPresenter.new(columns.by_position)
        render json: { columns: presenter.as_json }
      end

      def show
        presenter = ColumnPresenter.new(@column)
        render json: presenter.as_json, status: :ok
      end

      def create
        creator = ColumnCreator.new
        column = creator.call(board: @board, column_params: column_params)
        status = creator.succesful? ? :ok : :unprocessable_entity
        render json: { created: column }, status: status
      end

      def destroy
        destroyer = ColumnDestroyer.new
        column = destroyer.call(column: @column, board: @board)
        status = destroyer.succesful? ? :ok : :unprocessable_entity
        render json: { destroyed: column }, status: status
      end

      def update
        updater = ColumnUpdater.new

        if params[:to_position].present? && params[:to_board].present?
          column = updater.change_board(board: @board, column: @column, to_position: params[:to_position].to_i,
                                        to_board: params[:to_board].to_i)
        end

        if params[:to_position].present? && params[:to_board].nil?
          column = updater.change_position(board: @board, column: @column,
                                           to_position: params[:to_position].to_i)
        end

        column = updater.call(column: @column, column_params: column_params) if params[:to_position].nil?
        status = updater.succesful? ? :ok : :unprocessable_entity
        render json: { updated: column }, status: status
      end

      private

      def find_column
        @column = @board.columns.find(params[:id])
      end

      def find_board
        @board = Board.find(params[:board_id])
      end

      def column_params
        params.permit(:name, :board_id, :position)
      end
    end
  end
end
