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

ActiveRecord::Schema[7.1].define(version: 2025_06_16_235806) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false
    t.boolean "available", default: true, null: false
    t.index ["user_id", "date"], name: "index_availabilities_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.bigint "gig_id"
    t.datetime "last_message_at"
    t.integer "user1_unread_count", default: 0
    t.integer "user2_unread_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gig_id"], name: "index_conversations_on_gig_id"
    t.index ["user1_id", "user2_id"], name: "index_conversations_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_conversations_on_user1_id"
    t.index ["user2_id", "user1_id"], name: "index_conversations_on_user2_id_and_user1_id", unique: true
    t.index ["user2_id"], name: "index_conversations_on_user2_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.bigint "gig_id", null: false
    t.string "question"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gig_id"], name: "index_faqs_on_gig_id"
  end

  create_table "features", force: :cascade do |t|
    t.bigint "gig_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gig_id"], name: "index_features_on_gig_id"
  end

  create_table "gigs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.index ["user_id"], name: "index_gigs_on_user_id"
  end

  create_table "gigs_categories", force: :cascade do |t|
    t.bigint "gig_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_gigs_categories_on_category_id"
    t.index ["gig_id"], name: "index_gigs_categories_on_gig_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.boolean "read", default: false
    t.string "message_type", default: "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.bigint "gig_id", null: false
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "delivery_days"
    t.integer "revisions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gig_id"], name: "index_packages_on_gig_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.text "bio"
    t.string "location"
    t.string "phone"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "settings"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availabilities", "users"
  add_foreign_key "conversations", "gigs"
  add_foreign_key "conversations", "users", column: "user1_id"
  add_foreign_key "conversations", "users", column: "user2_id"
  add_foreign_key "faqs", "gigs"
  add_foreign_key "features", "gigs"
  add_foreign_key "gigs", "users"
  add_foreign_key "gigs_categories", "categories"
  add_foreign_key "gigs_categories", "gigs"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "packages", "gigs"
end
