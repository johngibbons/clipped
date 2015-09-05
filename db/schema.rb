# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150905154619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "commenter_id"
    t.integer  "commentee_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "body"
  end

  add_index "comments", ["commentee_id"], name: "index_comments_on_commentee_id", using: :btree
  add_index "comments", ["commenter_id", "commentee_id"], name: "index_comments_on_commenter_id_and_commentee_id", using: :btree
  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "favorited_id"
    t.integer  "favoriter_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "relationships", ["favorited_id"], name: "index_relationships_on_favorited_id", using: :btree
  add_index "relationships", ["favoriter_id", "favorited_id"], name: "index_relationships_on_favoriter_id_and_favorited_id", unique: true, using: :btree
  add_index "relationships", ["favoriter_id"], name: "index_relationships_on_favoriter_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "uploads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "views",              default: 0
    t.integer  "downloads",          default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "favorites_count",    default: 0
    t.boolean  "approved",           default: false,          null: false
    t.string   "direct_upload_url",                           null: false
    t.boolean  "processed",          default: false,          null: false
    t.integer  "perspective",        default: 0,              null: false
    t.integer  "category",           default: 0,              null: false
    t.string   "dz_thumb",           default: "/missing.png", null: false
  end

  add_index "uploads", ["created_at"], name: "index_uploads_on_created_at", using: :btree
  add_index "uploads", ["downloads", "created_at"], name: "index_uploads_on_downloads_and_created_at", using: :btree
  add_index "uploads", ["downloads"], name: "index_uploads_on_downloads", using: :btree
  add_index "uploads", ["favorites_count", "created_at", "views", "downloads"], name: "weighted_score", using: :btree
  add_index "uploads", ["favorites_count"], name: "index_uploads_on_favorites_count", using: :btree
  add_index "uploads", ["user_id", "created_at"], name: "index_uploads_on_user_id_and_created_at", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree
  add_index "uploads", ["views", "created_at"], name: "index_uploads_on_views_and_created_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                 default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_w"
    t.integer  "crop_h"
    t.integer  "favorites_count",       default: 0,     null: false
    t.integer  "downloads_count",       default: 0,     null: false
    t.integer  "views_count",           default: 0,     null: false
    t.string   "username"
    t.integer  "avatar_original_width", default: 0,     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "uploads", "users"
end
