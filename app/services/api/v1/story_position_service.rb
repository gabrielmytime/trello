# frozen_string_literal: true

module Api
  module V1
    class StoryPositionService
      # we move all the stories in a column
      # if our position > story.position then we increment story.position
      def move_down(position:, column:)
        column.stories.each do |story|
          story.update({ position: story.position + 1 }) if story.position <= position
        end
      end

      # we move all the stories in a column
      # if our position < story.position then we decrease story.position
      def move_up(position:, column:)
        column.stories.each do |story|
          story.update({ position: story.position - 1 }) if story.position > position
        end
      end

      # here we empty our position for the new insert
      # if story. position >= our position then we increment the story.position
      def empty_position(position:, column:)
        column.stories.each do |story|
          story.update({ position: story.position + 1 }) if story.position >= position
        end
      end

      # if our position > story.position we move down
      # otherwise we move up
      def update_position(story:, position:, column:)
        if story.position > position
          move_down(position: story.position, column: column)
        else
          move_up(position: story.position, column: column)
        end
        story.update({ position: position })
      end
    end
  end
end
