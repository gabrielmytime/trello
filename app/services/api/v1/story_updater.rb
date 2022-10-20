# frozen_string_literal: true

module Api
  module V1
    class StoryUpdater
      def successful?
        !!@successful
      end

      def call(story:, story_params:)
        ActiveRecord::Base.transaction do
          @successful = story.update(story_params)

          raise ActiveRecord::Rollback unless successful?
        end
        story
      end
    end
  end
end
