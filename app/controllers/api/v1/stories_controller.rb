# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      before_action :find_board
      before_action :find_column
      before_action :find_story, only: %i[show destroy update]

      # returns all Stories for a column
      def index
        stories = @column.stories

        # filtering
        stories = stories.filter_by_status([params[:status]]) if params[:status].present?
        stories = stories.filter_by_next_month if params[:due_date].present? && (params[:due_date].downcase == 'month')
        stories = stories.filter_by_next_week if params[:due_date].present? && (params[:due_date].downcase == 'week')

        # getting them by position
        presenter = StoriesPresenter.new(stories.by_position)
        # render json: presenter.as_json, status: :ok
        render json: stories.by_position, status: :ok
      end

      # read Story
      def show
        presenter = StoryPresenter.new(@story)
        render json: presenter.as_json, status: :ok
      end

      # creates Story
      def create
        creator = StoryCreator.new
        story = creator.call(column: @column, story_params: story_params)
        status = creator.succesful? ? :ok : :unprocessable_entity
        render json: { created: story }, status: status
      end

      # deletes Story
      def destroy
        destroyer = StoryDestroyer.new
        story = destroyer.call(story: @story, column: @column)
        status = destroyer.succesful? ? :ok : :unprocessable_entity
        render json: { destroyed: story }, status: status
      end

      # updates Story
      def update
        updater = StoryUpdater.new

        if params[:to_position].present? && params[:to_column].present?
          story = updater.change_column(column: @column, story: @story, to_position: params[:to_position].to_i,
                                        to_column: params[:to_column].to_i)
        end

        if params[:to_position].present? && params[:to_column].nil?
          story = updater.change_position(column: @column, story: @story,
                                          to_position: params[:to_position].to_i)
        end

        story = updater.call(story: @story, story_params: story_params) if params[:to_position].nil?

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

      # get Story params
      def story_params
        params.permit(:name, :due_date, :completed, :archived, :column_id, :status, :position)
      end
    end
  end
end
