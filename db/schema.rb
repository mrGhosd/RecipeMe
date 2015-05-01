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

ActiveRecord::Schema.define(version: 20150427084249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string  "provider"
    t.string  "uid"
  end

  add_index "authorizations", ["provider"], name: "index_authorizations_on_provider", using: :btree
  add_index "authorizations", ["uid"], name: "index_authorizations_on_uid", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "callbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "author"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate",       default: 0
  end

  add_index "comments", ["recipe_id"], name: "index_comments_on_recipe_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "imageable_type", limit: 255
    t.integer  "imageable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingridients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingridients", ["name"], name: "index_ingridients_on_name", using: :btree

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "rate",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["rate"], name: "index_news_on_rate", using: :btree
  add_index "news", ["title"], name: "index_news_on_title", using: :btree

  create_table "recipe_ingridients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingridient_id"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate",                                 default: 0
    t.integer  "comments_count",                       default: 0
    t.integer  "steps_count",                          default: 0
    t.integer  "recipe_ingridients_count",             default: 0
  end

  add_index "recipes", ["category_id"], name: "index_recipes_on_category_id", using: :btree
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "steps", force: :cascade do |t|
    t.integer  "recipe_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_updates", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "update_type"
    t.integer  "update_id"
    t.string   "update_entity"
    t.string   "update_entity_for"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_updates", ["type"], name: "index_user_updates_on_type", using: :btree
  add_index "user_updates", ["update_entity"], name: "index_user_updates_on_update_entity", using: :btree
  add_index "user_updates", ["update_entity_for"], name: "index_user_updates_on_update_entity_for", using: :btree
  add_index "user_updates", ["user_id"], name: "index_user_updates_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",     null: false
    t.string   "encrypted_password",     limit: 255, default: "",     null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "surname",                limit: 255
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.datetime "date_of_birth"
    t.string   "city",                   limit: 255
    t.string   "avatar",                 limit: 255
    t.string   "role",                               default: "user"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id"], name: "index_votes_on_voteable_id", using: :btree
  add_index "votes", ["voteable_type"], name: "index_votes_on_voteable_type", using: :btree

end
