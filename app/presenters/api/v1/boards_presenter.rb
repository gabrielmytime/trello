# frozen_string_literal: true

module Api
  module V1
    class BoardsPresenter
      attr_accessor :board

      def initialize(boards)
        @boards = boards
      end

      def data_as_json
        data = []
        @boards.each { |board| data << { 'board' => board, 'columns' => board.columns, 'stories' => board.stories } }
        { "data": data }
      end

      # def data_as_json(*)
      #   data = []
      #   Board.each do |board|
      #     data << board
      #     board.each do |column|
      #       data << column
      #       data << column.stories
      #     end
      #   end
      #   data
      # end

      def as_json(*)
        boards_json = []
        @boards.each do |board|
          boards_json << {
            "id": board.id,
            "name": board.name
          }
        end

        { "boards": boards_json }
      end
    end
  end
end
