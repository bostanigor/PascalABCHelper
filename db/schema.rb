# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_31_180020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attempts", force: :cascade do |t|
    t.text "code_text"
    t.string "status"
    t.bigint "solution_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["solution_id"], name: "index_attempts_on_solution_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "retry_interval"
    t.integer "code_text_limit"
    t.integer "singleton_guard", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "solutions", force: :cascade do |t|
    t.boolean "is_successfull", default: false
    t.integer "attempts_count", default: 0
    t.datetime "last_attempt_at"
    t.bigint "student_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_solutions_on_student_id"
    t.index ["task_id"], name: "index_solutions_on_task_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_students_on_group_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "rating", precision: 10, scale: 2
    t.integer "successfull_attempts", default: 0
    t.integer "all_attempts", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "attempts", "solutions"
  add_foreign_key "solutions", "students"
  add_foreign_key "solutions", "tasks"
  add_foreign_key "students", "groups"
  add_foreign_key "students", "users"
end
