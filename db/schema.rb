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

ActiveRecord::Schema.define(version: 20150828062905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string  "provider", limit: 255
    t.string  "uid",      limit: 255
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "callbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "author",     limit: 255
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

  create_table "complaints", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "complaintable_id"
    t.string   "complaintable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "complaints", ["complaintable_id"], name: "index_complaints_on_complaintable_id", using: :btree
  add_index "complaints", ["complaintable_type"], name: "index_complaints_on_complaintable_type", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "imageable_type", limit: 255
    t.integer  "imageable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingridients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "text"
    t.integer  "rate",                   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "recipe_ingridients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingridient_id"
    t.string   "size",          limit: 255
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
    t.integer  "time",                                 default: 0
    t.integer  "persons",                              default: 1
    t.string   "difficult"
    t.boolean  "delta",                                default: true, null: false
    t.string   "slug"
  end

  add_index "recipes", ["category_id"], name: "index_recipes_on_category_id", using: :btree
  add_index "recipes", ["delta"], name: "index_recipes_on_delta", using: :btree
  add_index "recipes", ["difficult"], name: "index_recipes_on_difficult", using: :btree
  add_index "recipes", ["persons"], name: "index_recipes_on_persons", using: :btree
  add_index "recipes", ["time"], name: "index_recipes_on_time", using: :btree
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

  create_table "sidekiq_jobs", force: :cascade do |t|
    t.string   "jid"
    t.string   "queue"
    t.string   "class_name"
    t.text     "args"
    t.boolean  "retry"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "status"
    t.string   "name"
    t.text     "result"
  end

  add_index "sidekiq_jobs", ["class_name"], name: "index_sidekiq_jobs_on_class_name", using: :btree
  add_index "sidekiq_jobs", ["enqueued_at"], name: "index_sidekiq_jobs_on_enqueued_at", using: :btree
  add_index "sidekiq_jobs", ["finished_at"], name: "index_sidekiq_jobs_on_finished_at", using: :btree
  add_index "sidekiq_jobs", ["jid"], name: "index_sidekiq_jobs_on_jid", using: :btree
  add_index "sidekiq_jobs", ["queue"], name: "index_sidekiq_jobs_on_queue", using: :btree
  add_index "sidekiq_jobs", ["retry"], name: "index_sidekiq_jobs_on_retry", using: :btree
  add_index "sidekiq_jobs", ["started_at"], name: "index_sidekiq_jobs_on_started_at", using: :btree
  add_index "sidekiq_jobs", ["status"], name: "index_sidekiq_jobs_on_status", using: :btree

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
    t.string   "update_type",       limit: 255
    t.integer  "update_id"
    t.string   "update_entity",     limit: 255
    t.string   "update_entity_for", limit: 255
    t.string   "type",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "voteable_type", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
