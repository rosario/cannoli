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

ActiveRecord::Schema.define(:version => 20090313181618) do

  create_table "actions", :force => true do |t|
    t.string   "url"
    t.integer  "visitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_id"
    t.integer  "kind"
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "visitors", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "localtime"
    t.integer  "returning"
    t.integer  "referer_type"
    t.text     "referer_name"
    t.text     "referer_url"
    t.text     "referer_keyword"
    t.text     "config_md5config"
    t.text     "config_os"
    t.text     "config_browser_name"
    t.text     "config_browser_version"
    t.text     "config_resolution"
    t.integer  "config_pdf"
    t.integer  "config_flash"
    t.integer  "config_java"
    t.integer  "config_director"
    t.integer  "config_quicktime"
    t.integer  "config_realplayer"
    t.integer  "config_windowsmedia"
    t.integer  "config_cookie"
    t.text     "location_ip"
    t.text     "location_browser_lang"
    t.text     "location_country"
    t.text     "location_continent"
    t.integer  "project_id"
  end

end
