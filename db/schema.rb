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

ActiveRecord::Schema.define(version: 20200225132827) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.integer  "permission"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "controls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "goods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "mutes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "notices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "sender"
    t.text     "content",         limit: 65535
    t.boolean  "read_flag"
    t.datetime "create_datetime"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "points", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.integer  "point",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.string   "tag_string"
    t.datetime "create_datetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "tweets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "content"
    t.datetime "create_datetime"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.bigint   "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "res_count",           default: 0
    t.integer  "good_count",          default: 0
    t.integer  "bookmark_count",      default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.bigint   "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "bad_count",           default: 0
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "encrypted_password",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "name"
    t.string   "avater_file_name"
    t.string   "avater_content_type"
    t.bigint   "avater_file_size"
    t.datetime "avater_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.bigint   "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "description",            limit: 65535
    t.string   "login_id",                             default: "", null: false
    t.string   "email",                                default: "", null: false
    t.datetime "last_tweet"
    t.index ["login_id"], name: "index_users_on_login_id", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
