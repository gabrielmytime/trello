# frozen_string_literal: true

module Api
  module V1
    class ColumnsController < ApplicationController
      before_action :find_board
      before_action :find_column, only: %i[show update destroy]

      def index
        @columns = @board.columns
        render json: ColumnsPresenter.new(@columns.by_position).as_json
      end

      def show
        render json: ColumnPresenter.new(@column).as_json
      end

      def create
        render json: ColumnCreator.new.call(board: @board, column_params: column_params)
      end

      def destroy
        render json: ColumnDestroyer.new.call(column: @column, board: @board)
      end

      def update
        updater = ColumnUpdater.new
        position_updater(updater: updater)
        column = updater.call(column: @column, column_params: column_params)
        render json: column
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

      def position_updater(updater:)
        if params[:to_position].present? && params[:to_board].present?
          column = updater.change_board(board: @board, column: @column,
                                        to_board: params[:to_board].to_i, to_position: params[:to_position].to_i)
        end

        if params[:to_position].present? && params[:to_board].nil?
          column = updater.change_position(board: @board, column: @column, to_position: params[:to_position].to_i)
        end
      end
    end
  end
end
