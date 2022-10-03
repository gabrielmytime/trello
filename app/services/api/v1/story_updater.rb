# frozen_string_literal: true

module Api
  module V1
    class StoryUpdater
      def initialize(position_service: Api::V1::StoryPositionService.new)
        @story_position_service = position_service
      end

      def succesful?
        !!@succesful
      end

      def change_position(column: ,story: , to_position:)
        current_position = story.position
        ActiveRecord::Base.transaction do
          @succesful = @story_position_service.update_position(column: column, current_position: current_position, to_position: to_position)

          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end

      def change_column(column:, story:, to_position:, to_column:)
        current_position = story.position
        current_column = column.id
        pp current_column
        pp current_position
        ActiveRecord::Base.transaction do
          @succesful = @story_position_service.update_column_and_position(current_column: current_column, current_position: current_position,
            to_column: to_column, to_position: to_position)
            
          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end

      def call(story:, story_params:)
        ActiveRecord::Base.transaction do
          @succesful = story.update(story_params)

          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end
    end
  end
end
