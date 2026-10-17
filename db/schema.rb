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

ActiveRecord::Schema[8.1].define(version: 2026_10_17_030749) do
  create_table "decisions", force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "reviewer_id", null: false
    t.string "outcome", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_decisions_on_request_id"
    t.index ["reviewer_id"], name: "index_decisions_on_reviewer_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "requester_email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviewers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_reviewers_on_email", unique: true
  end

  add_foreign_key "decisions", "requests"
  add_foreign_key "decisions", "reviewers"
end
