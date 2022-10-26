# frozen_string_literal: true

module Api
  module V1
    class StoriesPresenter
      attr_accessor :story

      def initialize(stories)
        @stories = stories
      end

      def stories
        stories = []
        @stories.each do |story|
          stories << {
            "id": story.id,
            "name": story.name,
            "due_date": story.due_date,
            "status": story.status,
            "column_id": story.column_id
          }
        end
        stories
      end

      def as_json(*)
        stories
      end
    end
  end
end
