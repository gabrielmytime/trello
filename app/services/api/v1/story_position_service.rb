# frozen_string_literal: true

module Api
  module V1
    class StoryPositionService
      def successful?
        !!@successful
      end

      def change_position(column:, story:, to_position:)
        current_position = story.position
        ActiveRecord::Base.transaction do
          @successful = update_position(column: column, current_position: current_position,
                                                               to_position: to_position)

          raise ActiveRecord::Rollback unless successful?
        end
        story
      end

      def change_column(column:, story:, to_position:, to_column:)
        current_position = story.position
        current_column = column.id
        ActiveRecord::Base.transaction do
          @successful = update_column_and_position(current_column: current_column, current_position: current_position,
                                                                          to_column: to_column, to_position: to_position)

          raise ActiveRecord::Rollback unless successful?
        end
        story
      end

      private 
      def update_position(column:, current_position:, to_position:)
        column.stories.update_all("position=case
          when position = #{current_position} then #{to_position}
          when position >= #{to_position} and #{to_position} < #{current_position} then position + 1
          when position <= #{to_position} and #{to_position} > #{current_position} then position - 1
        else position end")
      end

      def update_column_and_position(current_column:, current_position:, to_column:, to_position:)
        Story.where(column_id: [current_column, to_column]).update_all("position = case
            when position >= #{to_position} and column_id = #{to_column} then position + 1
            when position = #{current_position} and column_id = #{current_column} then #{to_position}
            else position
          end
          ,column_id = case
            when position = #{current_position} and column_id = #{current_column} then #{to_column}
            else column_id
          end
          ,position = case
            when position > #{current_position} and column_id = #{current_column} then position - 1
            else position
          end")
      end
    end
  end
end
