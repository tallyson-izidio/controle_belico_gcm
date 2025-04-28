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

ActiveRecord::Schema[7.1].define(version: 2025_04_26_214616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guards", force: :cascade do |t|
    t.string "full_name"
    t.string "matricula"
    t.string "porte_numero"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_guards_on_team_id"
  end

  create_table "movements", force: :cascade do |t|
    t.bigint "armeiro_id"
    t.bigint "guard_id"
    t.bigint "weapon_id", null: false
    t.string "movement_type", null: false
    t.date "date"
    t.time "time"
    t.integer "ammo_count"
    t.string "ammo_caliber"
    t.integer "magazine_count"
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["armeiro_id"], name: "index_movements_on_armeiro_id"
    t.index ["guard_id"], name: "index_movements_on_guard_id"
    t.index ["weapon_id"], name: "index_movements_on_weapon_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_teams_on_unit_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.boolean "admin", default: false, null: false
    t.boolean "first_access", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "model"
    t.string "registration"
    t.boolean "borrowed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guards", "teams"
  add_foreign_key "movements", "guards"
  add_foreign_key "movements", "guards", column: "armeiro_id"
  add_foreign_key "movements", "weapons"
  add_foreign_key "teams", "units"
end
