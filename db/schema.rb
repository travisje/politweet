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

ActiveRecord::Schema.define(version: 20170815002928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "party"
    t.string "chamber"
    t.string "district"
    t.string "state"
    t.string "category"
    t.string "twitter_handle"
    t.string "fec_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crp_id"
    t.index ["fec_id"], name: "index_candidates_on_fec_id"
  end

  create_table "committees", force: :cascade do |t|
    t.string "fec_id"
    t.string "name"
    t.string "election_cycles"
    t.string "candidate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["fec_id"], name: "index_committees_on_fec_id"
  end

  create_table "donations", force: :cascade do |t|
    t.datetime "date"
    t.string "fec_record_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "committee_id"
    t.string "rptcom_fec_id"
    t.integer "amount"
    t.integer "batch_id"
    t.string "full_name"
    t.string "employer"
    t.string "occupation"
    t.string "state"
    t.string "rpt_tp"
    t.string "transaction_pgi"
    t.string "image_num"
    t.string "transaction_tp"
    t.string "entity_tp"
    t.string "city"
    t.string "zip_code"
    t.string "tran_id"
    t.string "file_num"
    t.string "memo_cd"
    t.string "first_name"
    t.string "last_name"
    t.string "amndt_ind"
    t.string "memo_text"
    t.string "other_id"
    t.index ["rptcom_fec_id"], name: "index_donations_on_rptcom_fec_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tweets", force: :cascade do |t|
    t.string "text"
    t.string "tweet_url"
    t.integer "donation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "twitter_handle"
    t.string "name"
    t.string "twitter_token"
    t.string "twitter_secret"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
