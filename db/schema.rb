# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090810143654) do

  create_table "usages", :force => true do |t|
    t.datetime "period_from"
    t.integer  "min_used"
    t.decimal  "download"
    t.string   "fap"
    t.decimal  "upload"
    t.integer  "download_24hr"
    t.integer  "upload_24hr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site"
  end

  add_index "usages", ["site", "period_from"], :name => "index_usages_on_site_and_period_from"

  create_table "users", :force => true do |t|
    t.string   "site",                              :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "other_emails"
    t.integer  "warning_threshold"
    t.integer  "alert_threshold"
    t.boolean  "send_emails"
    t.boolean  "run_cron"
    t.string   "perishable_token",  :default => "", :null => false
    t.integer  "fap_threshold"
    t.datetime "last_run_at"
    t.string   "time_zone"
  end

  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["site"], :name => "index_users_on_site"

end
