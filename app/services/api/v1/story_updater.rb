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

      def change_position(story:, to_position:, column:)
        ActiveRecord::Base.transaction do
          @succesful = @story_position_service.update_position(story: story, position: to_position, column: column)

          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end

      def change_column(column:, story:, to_position:, to_column:)
        new_column = Column.find(to_column)
        ActiveRecord::Base.transaction do
          @story_position_service.move_up(position: story.position, column: column)

          @story_position_service.empty_position(position: to_position, column: new_column)

          story.update({ column_id: to_column })

          @succesful = story.update({ position: to_position })

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
