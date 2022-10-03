# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :name
      t.datetime :due_date
      t.string :status
      t.integer :column_id
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :stories, :deleted_at
  end
end
