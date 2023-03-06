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

ActiveRecord::Schema.define(version: 2023_02_11_161302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "member_contests", force: :cascade do |t|
    t.bigint "school_id"
    t.string "name"
    t.integer "list_contest"
    t.string "name_sertification"
    t.string "url_sertification"
    t.integer "total_peserta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_id"], name: "index_member_contests_on_school_id"
  end

  create_table "school_champions", force: :cascade do |t|
    t.string "name_school"
    t.string "type_pmr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "name_school"
    t.integer "type_pmr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sertification_member_contests", force: :cascade do |t|
    t.bigint "school_champion_id"
    t.string "name"
    t.string "list_contest"
    t.string "position"
    t.string "number_member_contest"
    t.string "url_file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["school_champion_id"], name: "index_sertification_member_contests_on_school_champion_id"
  end

  create_table "sertifications", force: :cascade do |t|
    t.string "name_file"
    t.integer "list_contest"
    t.integer "type_pmr"
    t.string "url_link"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
