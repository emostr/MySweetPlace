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

ActiveRecord::Schema[8.1].define(version: 2026_09_16_145600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}, null: false
    t.string "kind", null: false
    t.bigint "place_id", null: false
    t.integer "position", default: 0, null: false
    t.jsonb "style", default: {}, null: false
    t.jsonb "title", default: {}, null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.index ["place_id", "position"], name: "index_blocks_on_place_id_and_position"
  end

  create_table "guestbook_entries", force: :cascade do |t|
    t.string "author_name", null: false
    t.bigint "author_place_id"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.boolean "pinned", default: false, null: false
    t.bigint "place_id", null: false
    t.string "status", default: "visible", null: false
    t.datetime "updated_at", null: false
    t.index ["author_place_id"], name: "index_guestbook_entries_on_author_place_id"
    t.index ["place_id", "status", "created_at"], name: "index_guestbook_entries_on_place_id_and_status_and_created_at"
  end

  create_table "neighbourships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label"
    t.bigint "neighbour_id", null: false
    t.bigint "place_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["neighbour_id"], name: "index_neighbourships_on_neighbour_id"
    t.index ["place_id", "neighbour_id"], name: "index_neighbourships_on_place_id_and_neighbour_id", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.text "body", default: "", null: false
    t.text "body_html", default: "", null: false
    t.datetime "created_at", null: false
    t.bigint "image_ids", default: [], null: false, array: true
    t.boolean "pinned", default: false, null: false
    t.bigint "place_id", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id", "created_at"], name: "index_notes_on_place_id_and_created_at"
  end

  create_table "places", force: :cascade do |t|
    t.datetime "content_updated_at"
    t.datetime "created_at", null: false
    t.text "interests", default: [], null: false, array: true
    t.boolean "listed", default: true, null: false
    t.jsonb "profile", default: {}, null: false
    t.jsonb "settings", default: {}, null: false
    t.datetime "suspended_at"
    t.jsonb "theme", default: {}, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.citext "username", null: false
    t.index ["content_updated_at"], name: "index_places_on_content_updated_at"
    t.index ["interests"], name: "index_places_on_interests", using: :gin
    t.index ["user_id"], name: "index_places_on_user_id", unique: true
    t.index ["username"], name: "index_places_on_username", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "height"
    t.bigint "place_id", null: false
    t.string "purpose", null: false
    t.datetime "updated_at", null: false
    t.integer "width"
    t.index ["place_id"], name: "index_uploads_on_place_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.citext "email_address", null: false
    t.string "locale", default: "ru", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blocks", "places", on_delete: :cascade
  add_foreign_key "guestbook_entries", "places", column: "author_place_id", on_delete: :nullify
  add_foreign_key "guestbook_entries", "places", on_delete: :cascade
  add_foreign_key "neighbourships", "places", column: "neighbour_id", on_delete: :cascade
  add_foreign_key "neighbourships", "places", on_delete: :cascade
  add_foreign_key "notes", "places"
  add_foreign_key "places", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "uploads", "places"
end
