# frozen_string_literal: true

module Api
  module V1
    class StoryCreator
      def successful?
        !!@successful
      end

      def call(story_params:, column:)
        story = Story.new(story_params)
        story.column_id = column.id
        ActiveRecord::Base.transaction do
          @successful = story.save
          raise ActiveRecord::Rollback unless successful?
        end
        story
      end
    end
  end
end
