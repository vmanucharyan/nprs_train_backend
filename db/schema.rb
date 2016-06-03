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

ActiveRecord::Schema.define(version: 20160602073221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "source_images", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "trace_file_name"
    t.string   "trace_content_type"
    t.integer  "trace_file_size"
    t.datetime "trace_updated_at"
    t.boolean  "processed",            default: false, null: false
    t.boolean  "locked",               default: false, null: false
    t.string   "lock_id"
    t.datetime "locked_at"
  end

  create_table "symbol_samples", force: :cascade do |t|
    t.string   "char"
    t.json     "cser_light_features"
    t.json     "cser_heavy_features"
    t.integer  "source_image_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "x",                    null: false
    t.integer  "y",                    null: false
    t.integer  "width",                null: false
    t.integer  "height",               null: false
    t.float    "threshold"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "symbol_samples", ["source_image_id"], name: "index_symbol_samples_on_source_image_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "symbol_samples", "source_images"
end
