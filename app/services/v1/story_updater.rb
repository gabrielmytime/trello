# frozen_string_literal: true

module Api
  module V1
    class StoryUpdater
      def succesful?
        !!@succesful
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
