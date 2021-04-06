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

ActiveRecord::Schema.define(version: 2021_04_06_134936) do

  create_table "access_logs", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.datetime "access_datetime"
    t.string "ip_address"
    t.string "url"
    t.string "method"
    t.string "referer"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_datetime"], name: "index_access_logs_on_access_datetime"
    t.index ["ip_address"], name: "index_access_logs_on_ip_address"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bads", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_bads_on_create_datetime"
    t.index ["tweet_id"], name: "index_bads_on_tweet_id"
    t.index ["user_id"], name: "index_bads_on_user_id"
  end

  create_table "bookmarks", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_bookmarks_on_create_datetime"
    t.index ["tweet_id"], name: "index_bookmarks_on_tweet_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "card_boxes", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "size", default: 10
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "medal", default: 10
    t.boolean "trial", default: true, null: false
  end

  create_table "card_decks", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "card_box_id"
    t.integer "rule"
    t.integer "card_1_id"
    t.integer "card_2_id"
    t.integer "card_3_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_get_results", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_kings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "rule"
    t.integer "user_id"
    t.integer "card_deck_id"
    t.integer "defense", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_challenger_id"
  end

  create_table "cards", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "card_box_id"
    t.integer "model_id"
    t.integer "element"
    t.integer "power"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rare", default: false, null: false
    t.boolean "new", default: false, null: false
    t.integer "sub_element", default: 0
  end

  create_table "controls", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_controls_on_key"
  end

  create_table "follows", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "target_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_follows_on_create_datetime"
    t.index ["target_id"], name: "index_follows_on_target_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "gambling_results", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "result"
    t.integer "point"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "game"
  end

  create_table "goods", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_goods_on_create_datetime"
    t.index ["tweet_id"], name: "index_goods_on_tweet_id"
    t.index ["user_id"], name: "index_goods_on_user_id"
  end

  create_table "messages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sender_id"
    t.string "sender_name"
    t.string "title"
    t.string "content"
    t.boolean "read_flag"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_messages_on_create_datetime"
    t.index ["read_flag"], name: "index_messages_on_read_flag"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "mutes", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "target_id"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id"], name: "index_mutes_on_target_id"
    t.index ["user_id"], name: "index_mutes_on_user_id"
  end

  create_table "news", charset: "utf8mb4", force: :cascade do |t|
    t.integer "priority"
    t.datetime "expiration"
    t.string "news"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expiration"], name: "index_news_on_expiration"
    t.index ["priority"], name: "index_news_on_priority"
  end

  create_table "notices", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sender_id"
    t.string "sender_name"
    t.string "title"
    t.string "content"
    t.boolean "read_flag"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_notices_on_create_datetime"
    t.index ["read_flag"], name: "index_notices_on_read_flag"
    t.index ["sender_id"], name: "index_notices_on_sender_id"
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "points", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "point", default: 10000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "premia", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "limit_datetime"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_premia_on_create_datetime"
    t.index ["limit_datetime"], name: "index_premia_on_limit_datetime"
    t.index ["user_id"], name: "index_premia_on_user_id"
  end

  create_table "stats", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "datetime"
    t.integer "load"
    t.integer "users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_stats_on_datetime"
    t.index ["load"], name: "index_stats_on_load"
    t.index ["users"], name: "index_stats_on_users"
  end

  create_table "stock_companies", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "price_target"
    t.float "price"
    t.float "coefficient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_logs", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "datetime"
    t.integer "point", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_stock_logs_on_datetime"
  end

  create_table "stocks", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.string "tag_string"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_string"], name: "index_tags_on_tag_string"
    t.index ["tweet_id"], name: "index_tags_on_tweet_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "taxpayer_hofs", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tax", default: 0
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxpayers", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tax", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "texts", charset: "utf8mb4", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_texts_on_create_datetime"
    t.index ["tweet_id"], name: "index_texts_on_tweet_id"
    t.index ["user_id"], name: "index_texts_on_user_id"
  end

  create_table "thumbs", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumb_file_name"
    t.string "thumb_content_type"
    t.bigint "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.index ["key"], name: "index_thumbs_on_key"
  end

  create_table "tiramon_battle_prizes", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "prize"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiramon_battles", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "datetime"
    t.integer "red_tiramon_id"
    t.integer "blue_tiramon_id"
    t.integer "result"
    t.string "result_str"
    t.text "data", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "schedule"
    t.integer "rank"
    t.boolean "payment", default: false, null: false
    t.datetime "payment_time"
    t.string "red_tiramon_name"
    t.string "blue_tiramon_name"
    t.integer "match_time", default: 0
    t.index ["blue_tiramon_id"], name: "index_tiramon_battles_on_blue_tiramon_id"
    t.index ["datetime"], name: "index_tiramon_battles_on_datetime"
    t.index ["rank"], name: "index_tiramon_battles_on_rank"
    t.index ["red_tiramon_id"], name: "index_tiramon_battles_on_red_tiramon_id"
    t.index ["result"], name: "index_tiramon_battles_on_result"
  end

  create_table "tiramon_bets", charset: "utf8mb4", force: :cascade do |t|
    t.integer "tiramon_battle_id"
    t.integer "user_id"
    t.integer "bet"
    t.integer "bet_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiramon_enemies", charset: "utf8mb4", force: :cascade do |t|
    t.integer "enemy_class"
    t.integer "stage"
    t.integer "enemy_id"
    t.string "name"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiramon_factor_names", charset: "utf8mb4", force: :cascade do |t|
    t.string "key"
    t.text "factor", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tiramon_factors", charset: "utf8mb4", force: :cascade do |t|
    t.string "key"
    t.text "factor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tiramon_moves", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "data", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "move_id"
  end

  create_table "tiramon_templates", charset: "utf8mb4", force: :cascade do |t|
    t.integer "level"
    t.string "name"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiramon_trainers", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "level", default: 0
    t.integer "experience", default: 0
    t.integer "tiramon_ball", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "move", default: 3
  end

  create_table "tiramon_trainings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "level", default: 0
    t.text "training"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiramons", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "move"
    t.integer "experience", default: 0
    t.integer "tiramon_trainer_id"
    t.text "get_move"
    t.datetime "act"
    t.datetime "get_limit"
    t.integer "right"
    t.text "training_text"
    t.integer "rank", default: 3
    t.integer "auto_rank"
    t.text "adventure_data"
    t.datetime "adventure_time"
    t.datetime "bonus_time"
    t.text "factor"
    t.string "factor_name"
    t.text "pedigree"
    t.index ["tiramon_trainer_id"], name: "index_tiramons_on_tiramon_trainer_id"
  end

  create_table "tweets", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "parent_id"
    t.string "content"
    t.datetime "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "res_count", default: 0
    t.integer "good_count", default: 0
    t.integer "bookmark_count", default: 0
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "bad_count", default: 0
    t.integer "context", default: 0
    t.boolean "nsfw"
    t.float "humanity", default: 0.0
    t.float "sensitivity", default: 0.0
    t.integer "adult", default: 0
    t.integer "spoof", default: 0
    t.integer "medical", default: 0
    t.integer "violence", default: 0
    t.integer "racy", default: 0
    t.string "content_ja"
    t.string "content_en"
    t.string "content_zh"
    t.string "language"
    t.float "language_confidence", default: 0.0
    t.string "content_ru"
    t.integer "wakaru_count", default: 0
    t.integer "view_count", default: 0
    t.index ["parent_id"], name: "index_tweets_on_parent_id"
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: ""
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text "description"
    t.datetime "last_tweet"
    t.integer "last_check_res", default: 0
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wakarus", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_id"
    t.integer "create_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["create_datetime"], name: "index_wakarus_on_create_datetime"
    t.index ["tweet_id"], name: "index_wakarus_on_tweet_id"
    t.index ["user_id"], name: "index_wakarus_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
