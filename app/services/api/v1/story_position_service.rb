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
      def update_position_in_column(story:, position:, column:)
        column.stories.update_all("position=case 
          when position = #{current_position} then #{to_position} 
          when position >= #{to_position} and #{to_position} < #{current_position} then position + 1 
          when position <= #{to_position} and #{to_position} > #{current_position} then position - 1  
        else position end"
        )
          
      def change_column_and_position(story:, to_position:, to_column:, column:)
        Column.where(column_id: [column.id,to_column]).update_all("
          position = case 
            when position >= #{to_position} and column_id = #{to_column} then position + 1
            else position
            end
          ,column_id = case 
            when position = #{current_position} and column_id = #{current_column} then #{to_column} 
            else column_id 
            end
          ,position = case 
            when position > #{current_position} and column_id = #{current_column} then position - 1
            else position
            end
          ")
      end

        # if story.position > position
        #   move_down(position: story.position, column: column)
        # else
        #   move_up(position: story.position, column: column)
        # end
        # story.update({ position: position })
      end
    end
  end
end
