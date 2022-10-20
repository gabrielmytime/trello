# frozen_string_literal: true

module Api
  module V1
    class StoriesFilter
      attr_reader :stories, :filters

      def initialize(stories: , filters:)
        @stories = stories
        @filters = filters
      end

      def call
        self.filter
      end

      def filter
        if filters[:status]
          @stories = stories.filter_by_status(filters[:status])
        end
    
        if filters[:due_date] && filters[:due_date].downcase == 'month'
          @stories = stories.filter_by_week
        end

        if filters[:due_date] && filters[:due_date].downcase == 'week'
          @stories = stories.filter_by_month
        end
        stories
      end
    end
  end
end
