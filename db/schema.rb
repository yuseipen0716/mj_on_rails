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

ActiveRecord::Schema[8.0].define(version: 2025_09_14_201948) do
  create_table "dora_indicators", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "player_id", null: false
    t.string "tile", limit: 10, null: false
    t.integer "position", null: false
    t.integer "source", default: 0, null: false
    t.integer "turn_number", default: 0, null: false
    t.integer "action_sequence", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "created_at"], name: "index_dora_indicators_on_game_id_and_created_at"
    t.index ["game_id", "position"], name: "index_dora_indicators_on_game_id_and_position", unique: true
    t.index ["game_id", "turn_number"], name: "index_dora_indicators_on_game_id_and_turn_number"
    t.index ["game_id"], name: "index_dora_indicators_on_game_id"
    t.index ["player_id"], name: "index_dora_indicators_on_player_id"
    t.index ["source"], name: "index_dora_indicators_on_source"
  end

  create_table "game_events", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "player_id", null: false
    t.integer "event_type", null: false
    t.text "data"
    t.integer "turn_number", default: 0, null: false
    t.integer "action_sequence", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_game_events_on_event_type"
    t.index ["game_id", "created_at"], name: "index_game_events_on_game_id_and_created_at"
    t.index ["game_id", "event_type"], name: "index_game_events_on_game_id_and_event_type"
    t.index ["game_id", "turn_number"], name: "index_game_events_on_game_id_and_turn_number"
    t.index ["game_id"], name: "index_game_events_on_game_id"
    t.index ["player_id", "event_type"], name: "index_game_events_on_player_id_and_event_type"
    t.index ["player_id"], name: "index_game_events_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.integer "status", default: 0, null: false
    t.integer "turn", default: 0
    t.integer "current_player", default: 0
    t.text "wall"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_games_on_created_at"
    t.index ["status"], name: "index_games_on_status"
  end

  create_table "players", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.integer "position", default: 0, null: false
    t.integer "wind", default: 0, null: false
    t.text "hand"
    t.integer "score", default: 25000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "position"], name: "index_players_on_game_id_and_position", unique: true
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id", "game_id"], name: "index_players_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_players_on_user_id"
    t.check_constraint "position >= 0 AND position <= 3", name: "valid_position"
    t.check_constraint "wind >= 0 AND wind <= 3", name: "valid_wind"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", limit: 255, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "dora_indicators", "games"
  add_foreign_key "dora_indicators", "players"
  add_foreign_key "game_events", "games"
  add_foreign_key "game_events", "players"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
end
