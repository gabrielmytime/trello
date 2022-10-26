# frozen_string_literal: true

module Api
  module V1
    class StoryPresenter
      attr_accessor :story

      def initialize(story)
        @story = story
      end

      def as_json(*)
        {
          "id": @story.id,
          "name": @story.name,
          "due_date": @story.due_date, # edit date to look nicer
          "status": @story.status,
          "column_id": @story.column_id
        }
      end
    end
  end
end
