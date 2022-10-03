# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      before_action :find_board
      before_action :find_column
      before_action :find_story, only: %i[show destroy update]

      def index
        stories = filtered_stories(@column.stories)

        presenter = StoriesPresenter.new(stories.by_position)
        render json: presenter.as_json
      end

      def show
        presenter = StoryPresenter.new(@story)
        render json: presenter.as_json, status: :ok
      end

      def create
        creator = StoryCreator.new
        story = creator.call(column: @column, story_params: story_params)
        status = creator.succesful? ? :ok : :unprocessable_entity
        render json: { created: story }, status: status
      end

      def destroy
        destroyer = StoryDestroyer.new
        story = destroyer.call(story: @story, column: @column)
        status = destroyer.succesful? ? :ok : :unprocessable_entity
        render json: { destroyed: story }, status: status
      end

      def update
        updater = StoryUpdater.new
        position_updater(updater: updater)
        story = updater.call(story: @story, story_params: story_params)

        status = updater.succesful? ? :ok : :unprocessable_entity
        render json: { updated: story }, status: status
      end

      private

      def find_story
        @story = @column.stories.find(params[:id])
      end

      def find_column
        @column = @board.columns.find(params[:column_id])
      end

      def find_board
        @board = Board.find(params[:board_id])
      end

      def story_params
        params.permit(:name, :due_date, :status, :column_id,  :position)
      end

      def position_updater(updater:)
        if params[:to_position].present? && params[:to_column].present?
          story = updater.change_column(column: @column, story: @story,
            to_column: params[:to_column].to_i, to_position: params[:to_position].to_i)
        end

        if params[:to_position].present? && params[:to_column].nil?
          story = updater.change_position(column: @column, story: @story, to_position: params[:to_position].to_i)
        end
      end

      def filtered_stories(stories:)
        stories = stories.filter_by_status([params[:status]]) if params[:status].present?

        stories = stories.filter_by_next_month if params[:due_date].present? && (params[:due_date].downcase == 'month')
        
        stories = stories.filter_by_next_week if params[:due_date].present? && (params[:due_date].downcase == 'week')
        
        stories
      end
    end
  end
end
