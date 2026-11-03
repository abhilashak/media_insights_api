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

ActiveRecord::Schema[8.1].define(version: 2026_11_01_150359) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.string "source_type", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_mentions_on_account_id"
    t.check_constraint "source_type::text = ANY (ARRAY['news'::character varying, 'blog'::character varying, 'social_media'::character varying]::text[])", name: "mentions_valid_source_type"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "idx_users_lower_email", unique: true
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  add_foreign_key "mentions", "accounts"
  add_foreign_key "users", "accounts"
end
