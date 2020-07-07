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

ActiveRecord::Schema.define(version: 2018_12_13_132949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "notifiable_type"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "billing_addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address_line_one"
    t.string "address_two_one"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "state"
    t.index ["user_id"], name: "index_billing_addresses_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.string "state"
    t.string "charge_id"
    t.date "update_at"
    t.bigint "user_id"
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
  end

  create_table "countries", force: :cascade do |t|
    t.string "sortname"
    t.string "name"
    t.integer "phonecode"
  end

  create_table "country_by_regions", force: :cascade do |t|
    t.string "country"
    t.string "region"
  end

  create_table "customer_cards", force: :cascade do |t|
    t.string "customer_id"
    t.string "customer_card"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customer_cards_on_user_id"
  end

  create_table "deal_breakers", force: :cascade do |t|
    t.boolean "age"
    t.boolean "height"
    t.boolean "marital_status"
    t.boolean "have_children"
    t.boolean "religion"
    t.boolean "community"
    t.bigint "partner_preference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "country"
    t.boolean "state"
    t.index ["partner_preference_id"], name: "index_deal_breakers_on_partner_preference_id"
  end

  create_table "diets", force: :cascade do |t|
    t.string "name"
  end

  create_table "early_bird_registrations", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "education_concentrations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string "name"
  end

  create_table "incomes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer "user_to"
    t.date "updated_on"
    t.string "state"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "conv_id"
    t.datetime "notified_on"
    t.index ["user_id"], name: "index_interests_on_user_id"
  end

  create_table "jobstatuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_conversation_opt_outs", id: :serial, force: :cascade do |t|
    t.string "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :serial, force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", id: :serial, force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.string "notified_object_type"
    t.integer "notified_object_id"
    t.string "attachment"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["notified_object_type", "notified_object_id"], name: "mailboxer_notifications_notified_object"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :serial, force: :cascade do |t|
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "marital_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.boolean "terms_accepted_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "inform_admin", default: true
    t.boolean "export_data", default: false
    t.datetime "export_request_on"
    t.datetime "export_accepted_on"
    t.string "file_path"
    t.string "attachment"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "nakshatras", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "recipient_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.boolean "seen", default: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partner_preferences", force: :cascade do |t|
    t.integer "age_from"
    t.integer "age_to"
    t.float "height_from"
    t.float "height_to"
    t.string "marital_status"
    t.string "have_children"
    t.string "community"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "state"
    t.index ["user_id"], name: "index_partner_preferences_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "photo_type"
    t.string "sequence"
    t.boolean "active", default: true
    t.string "url"
    t.string "photo"
    t.string "workflow_state", default: "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_for"
    t.boolean "private_pic", default: false
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "policy_manager_portability_requests", force: :cascade do |t|
    t.integer "user_id"
    t.string "state"
    t.string "attachment"
    t.string "attachment_file_name"
    t.string "attachment_file_size"
    t.datetime "attachment_content_type"
    t.string "attachment_file_content_type"
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_policy_manager_portability_requests_on_user_id"
  end

  create_table "policy_manager_terms", force: :cascade do |t|
    t.text "description"
    t.string "rule"
    t.string "state"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policy_manager_user_terms", force: :cascade do |t|
    t.integer "user_id"
    t.integer "term_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state"], name: "index_policy_manager_user_terms_on_state"
    t.index ["term_id"], name: "index_policy_manager_user_terms_on_term_id"
    t.index ["user_id"], name: "index_policy_manager_user_terms_on_user_id"
  end

  create_table "profile_matches", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "match_user_id"
    t.datetime "match_sent_on"
    t.index ["user_id"], name: "index_profile_matches_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "gender"
    t.date "dob"
    t.text "about_me"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_state"
    t.string "facebook"
    t.string "instagram"
    t.string "country"
    t.string "member_relationship"
    t.boolean "photo", default: false
    t.string "marital_status"
    t.string "community"
    t.string "education_level"
    t.string "have_children"
    t.string "state"
    t.string "city"
    t.float "height"
    t.string "mobile_number"
    t.string "phone_number"
    t.string "linkedin"
    t.string "diet"
    t.string "smoke"
    t.string "drink"
    t.string "is_manglik"
    t.string "time_of_birth"
    t.string "values"
    t.string "country_raised"
    t.string "income"
    t.string "occupation"
    t.string "education_concentration"
    t.string "nakshatra"
    t.string "religion"
    t.string "country_of_birth"
    t.string "state_of_birth"
    t.string "city_of_birth"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "continent"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "religions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "initiated_by"
    t.bigint "approved_by"
    t.string "status"
    t.string "module"
    t.text "comment"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_by_regions", force: :cascade do |t|
    t.string "state"
    t.string "region"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "admin"
    t.string "region"
    t.string "state"
    t.string "middle_name"
    t.datetime "expiration_date"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "allow_password_change", default: "f"
    t.json "tokens"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "values", force: :cascade do |t|
    t.string "name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "workflow_statuses", force: :cascade do |t|
    t.string "module"
    t.string "state"
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "user_id"
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workflow_statuses_on_user_id"
  end

  add_foreign_key "activities", "users"
  add_foreign_key "billing_addresses", "users"
  add_foreign_key "charges", "users"
  add_foreign_key "customer_cards", "users"
  add_foreign_key "deal_breakers", "partner_preferences"
  add_foreign_key "interests", "users"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "photos", "users"
  add_foreign_key "profile_matches", "users"
  add_foreign_key "profile_matches", "users", column: "match_user_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "requests", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "workflow_statuses", "users"
end
