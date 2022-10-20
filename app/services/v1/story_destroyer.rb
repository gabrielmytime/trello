# frozen_string_literal: true

module Api
  module V1
    class StoryDestroyer
      def succesful?
        !!@succesful
      end

      def call(story:, column:)
        ActiveRecord::Base.transaction do
          @succesful = story.destroy
          raise ActiveRecord::Rollback unless succesful?
        end
        story
      end
    end
  end
end
