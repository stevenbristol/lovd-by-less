# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["profile_id"], :name => "index_blogs_on_profile_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "profile_id"
    t.string   "commentable_type", :default => "",    :null => false
    t.integer  "commentable_id",                      :null => false
    t.integer  "is_denied",        :default => 0,     :null => false
    t.boolean  "is_reviewed",      :default => false
  end

  add_index "comments", ["profile_id"], :name => "index_comments_on_profile_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "feed_items", :force => true do |t|
    t.boolean  "include_comments", :default => false, :null => false
    t.boolean  "is_public",        :default => false, :null => false
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["item_id", "item_type"], :name => "index_feed_items_on_item_id_and_item_type"

  create_table "feeds", :force => true do |t|
    t.integer "profile_id"
    t.integer "feed_item_id"
  end

  add_index "feeds", ["profile_id", "feed_item_id"], :name => "index_feeds_on_profile_id_and_feed_item_id"

  create_table "friends", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invited_id"
    t.integer  "status",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["inviter_id", "invited_id"], :name => "index_friends_on_inviter_id_and_invited_id", :unique => true
  add_index "friends", ["invited_id", "inviter_id"], :name => "index_friends_on_invited_id_and_inviter_id", :unique => true

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read",        :default => false, :null => false
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"

  create_table "photos", :force => true do |t|
    t.string   "caption",    :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "image"
  end

  add_index "photos", ["profile_id"], :name => "index_photos_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "blog"
    t.string   "flickr"
    t.text     "about_me"
    t.string   "aim_name"
    t.string   "gtalk_name"
    t.string   "ichat_name"
    t.string   "icon"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.boolean  "is_active",        :default => false
    t.string   "youtube_username"
    t.string   "flickr_username",  :default => "",    :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "is_admin"
    t.boolean  "can_send_messages",                       :default => true
    t.string   "time_zone",                               :default => "UTC"
    t.string   "email_verification"
    t.boolean  "email_verified"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
