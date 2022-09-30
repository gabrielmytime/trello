# frozen_string_literal: true

module Api
  module V1
    class StoryCreator
      def succesful?
        !!@succesful
      end

      def call(story_params:, column:)
        story = Story.new(story_params)
        story.column_id = column.id
        story.position = column.stories.count + 1
        ActiveRecord::Base.transaction do
          @succesful = story.save

          raise ActiveRecord::Rollback unless succesful?
        end

        story
      end
    end
  end
end
