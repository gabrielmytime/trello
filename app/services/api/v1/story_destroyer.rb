# frozen_string_literal: true

module Api
  module V1
    class StoryDestroyer
      def successful?
        !!@successful
      end

      def call(story:, column:)
        ActiveRecord::Base.transaction do
          @successful = story.destroy
          raise ActiveRecord::Rollback unless successful?
        end
        story
      end
    end
  end
end
