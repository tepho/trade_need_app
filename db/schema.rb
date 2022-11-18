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

ActiveRecord::Schema[7.0].define(version: 2022_11_17_235221) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.integer "origin_id", null: false
    t.integer "destiny_id"
    t.string "transaction_type_id", null: false
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_transactions_on_discarded_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "cpf", null: false
    t.string "email", null: false
    t.string "phone"
    t.date "birthday"
    t.decimal "balance", null: false
    t.string "password", null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
  end

end
