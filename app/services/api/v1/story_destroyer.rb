# frozen_string_literal: true

module Api
  module V1
    class StoryDestroyer
      def initialize(position_service: Api::V1::StoryPositionService.new)
        @story_position_service = position_service
      end

      def succesful?
        !!@succesful
      end

      def call(story:, column:)
        ActiveRecord::Base.transaction do
          @succesful = story.destroy
          @story_position_service.move_up(column: column, position: story.position)
          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end
    end
  end
end
