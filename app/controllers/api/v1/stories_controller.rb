# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      before_action :find_board
      before_action :find_column
      before_action :find_story, only: %i[show destroy update]

      def index
        stories = Api::V1::StoriesFilter.new(stories: @column.stories, filters: params).call
        presenter = Api::V1::StoriesPresenter.new(stories.by_position)
        render :json => { stories: presenter.as_json }
      end

      def show
        presenter = Api::V1::StoryPresenter.new(@story)
        render :json => { story: presenter.as_json }
      end

      def create
        creator = Api::V1::StoryCreator.new
        story = creator.call(column: @column, story_params: story_params)
        status = creator.successful? :ok : :unprocessable_entity
        presenter = Api::V1::StoryPresenter.new(story)
        render :json => { story: presenter.as_json }, status: status
      end

      def destroy
        destroyer = Api::V1::StoryDestroyer.new
        destroyer.call(story: @story, column: @column)
        status = destroyer.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::StoryPresenter.new(@story)
        render :json => { story: presenter.as_json }, status: status
      end

      def update
        updater = StoryUpdater.new
        position_updater
        story = updater.call(story: @story, story_params: story_params)
        status = updater.successful? ? :ok : :unprocessable_entity
        presenter = Api::V1::StoryPresenter.new(@story)
        render :json => { story: presenter.as_json }, status: status
      end

      private
      def position_updater
        if params[:to_position].present? && params[:to_column].present?
          story = StoryPositionService.new.change_column(column: @column, story: @story,
                                        to_column: params[:to_column].to_i, to_position: params[:to_position].to_i)
        end

        if params[:to_position].present? && params[:to_column].nil?
          story = StoryPositionService.new.change_position(column: @column, story: @story, 
                                        to_position: params[:to_position].to_i)
        end
      end

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
        params.permit(:name, :due_date, :status, :column_id, :position)
      end

      
    end
  end
end
