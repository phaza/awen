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

ActiveRecord::Schema.define(:version => 20100216002947) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "podcast_subscriptions", :force => true do |t|
    t.string   "title"
    t.string   "image"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcasts", :force => true do |t|
    t.string   "mime"
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "path"
    t.datetime "published_at"
    t.string   "duration"
    t.string   "guid"
    t.integer  "podcast_subscription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "downloaded",              :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                  :null => false
    t.string   "encrypted_password",   :limit => 40,                     :null => false
    t.string   "password_salt",                                          :null => false
    t.string   "reset_password_token", :limit => 20
    t.string   "remember_token",       :limit => 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",                 :limit => 128
    t.string   "confirmation_token",   :limit => 128
    t.boolean  "email_confirmed",                     :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
