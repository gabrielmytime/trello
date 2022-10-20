# frozen_string_literal: true

module Api
  module V1
    class ColumnsController < ApplicationController
      before_action :find_board
      before_action :find_column, only: %i[show update destroy]

      def index
        @columns = @board.columns
        presenter = Api::V1::ColumnsPresenter.new(@columns.by_position)
        render :json => { columns: presenter.as_json }
      end

      def show
        presenter = Api::V1::ColumnPresenter.new(@column)
        render :json => { column: presenter.as_json }
      end

      def create
        creator = Api::V1::ColumnCreator.new
        column = creator.call(board: @board, column_params: column_params)
        status = creator.successful? :ok : :unprocessable_entity
        presenter = Api::V1::ColumnPresenter.new(column)
        render :json => { column: presenter.as_json }, status: status
      end

      def destroy
        destroyer = Api::V1::ColumnDestroyer.new
        destroyer.call(column: @column, board: @board)
        status = destroyer.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::ColumnPresenter.new(@column)
        render :json => { column: presenter.as_json }, status: status
      end

      def update
        updater = ColumnUpdater.new
        position_updater
        updater.call(column: @column, column_params: column_params)
        status = updater.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::ColumnPresenter.new(@column)
        render :json => { column: presenter.as_json }, status: status
      end

      private
      def position_updater
        if params[:to_position].present? && params[:to_board].present?
          column = Api::V1::ColumnPositionService.new.change_board(board: @board, column: @column,
                                        to_board: params[:to_board].to_i, to_position: params[:to_position].to_i)
        end

        if params[:to_position].present? && params[:to_board].nil?
          column = Api::V1::ColumnPositionService.new.change_position(board: @board, column: @column, to_position: params[:to_position].to_i)
        end
      end

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
