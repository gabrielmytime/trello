# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_220_930_061_047) do
  create_table 'boards', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci',
                         options: '/*!50100 TABLESPACE `innodb_system` */ ENGINE=InnoDB', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'deleted_at'
    t.index ['deleted_at'], name: 'index_boards_on_deleted_at'
  end

  create_table 'columns', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci',
                          options: '/*!50100 TABLESPACE `innodb_system` */ ENGINE=InnoDB', force: :cascade do |t|
    t.string 'name'
    t.integer 'board_id'
    t.integer 'position'
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['deleted_at'], name: 'index_columns_on_deleted_at'
  end

  create_table 'stories', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci',
                          options: '/*!50100 TABLESPACE `innodb_system` */ ENGINE=InnoDB', force: :cascade do |t|
    t.string 'name'
    t.datetime 'due_date'
    t.string 'status'
    t.integer 'column_id'
    t.integer 'position'
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['deleted_at'], name: 'index_stories_on_deleted_at'
  end
end
