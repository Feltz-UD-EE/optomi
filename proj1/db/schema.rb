# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141212173214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_logs", force: true do |t|
    t.text     "request"
    t.text     "params"
    t.integer  "user_id"
    t.integer  "patient_id"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "access_tokens", force: true do |t|
    t.string   "token",           null: false
    t.string   "refresh_token",   null: false
    t.integer  "auth_type",       null: false
    t.integer  "user_id"
    t.integer  "api_client_id",   null: false
    t.datetime "expires_at",      null: false
    t.datetime "revoked_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "patient_id"
    t.integer  "organization_id"
  end

  add_index "access_tokens", ["patient_id"], name: "index_access_tokens_on_patient_id", using: :btree
  add_index "access_tokens", ["refresh_token"], name: "index_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "access_tokens", ["token"], name: "index_access_tokens_on_token", unique: true, using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "access_level"
    t.integer  "user_id"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "alert_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alert_occurrences", force: true do |t|
    t.integer  "alert_id"
    t.datetime "reviewed_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "recorded_value"
    t.integer  "patient_id",     null: false
  end

  add_index "alert_occurrences", ["alert_id"], name: "index_alert_occurrences_on_alert_id", using: :btree
  add_index "alert_occurrences", ["patient_id"], name: "index_alert_occurrences_on_patient_id", using: :btree

  create_table "alerts", force: true do |t|
    t.integer  "user_id",                                       null: false
    t.integer  "patient_id"
    t.boolean  "all_patients",                  default: false, null: false
    t.boolean  "message"
    t.string   "message_type"
    t.integer  "measurement_id"
    t.string   "polarity"
    t.string   "lower_threshold"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "deleted_at"
    t.integer  "alert_category_id",                             null: false
    t.string   "upper_threshold"
    t.integer  "patient_custom_measurement_id"
    t.string   "fractional_measurement_type"
  end

  add_index "alerts", ["alert_category_id"], name: "index_alerts_on_alert_category_id", using: :btree
  add_index "alerts", ["measurement_id"], name: "index_alerts_on_measurement_id", using: :btree
  add_index "alerts", ["patient_custom_measurement_id"], name: "index_alerts_on_patient_custom_measurement_id", using: :btree
  add_index "alerts", ["patient_id"], name: "index_alerts_on_patient_id", using: :btree
  add_index "alerts", ["user_id"], name: "index_alerts_on_user_id", using: :btree

  create_table "api_access_logs", force: true do |t|
    t.text     "request"
    t.text     "params"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "api_client_id"
    t.integer  "user_id"
  end

  add_index "api_access_logs", ["created_at"], name: "index_api_access_logs_on_created_at", using: :btree

  create_table "api_client_roles", force: true do |t|
    t.integer  "api_client_id", null: false
    t.integer  "role_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "api_client_roles", ["api_client_id", "role_id"], name: "index_api_client_roles_on_api_client_id_and_role_id", unique: true, using: :btree
  add_index "api_client_roles", ["api_client_id"], name: "index_api_client_roles_on_api_client_id", using: :btree
  add_index "api_client_roles", ["role_id"], name: "index_api_client_roles_on_role_id", using: :btree

  create_table "api_clients", force: true do |t|
    t.string   "name",                         null: false
    t.string   "access_token",                 null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "uid"
    t.boolean  "can_proxy",    default: false, null: false
    t.string   "client_type"
  end

  add_index "api_clients", ["uid"], name: "index_api_clients_on_uid", unique: true, using: :btree

  create_table "api_error_logs", force: true do |t|
    t.string   "api_version"
    t.text     "request"
    t.text     "params"
    t.string   "internal_code"
    t.integer  "http_code"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "exception_message"
    t.text     "exception_backtrace"
    t.integer  "api_client_id"
    t.integer  "user_id"
  end

  add_index "api_error_logs", ["created_at"], name: "index_api_error_logs_on_created_at", using: :btree
  add_index "api_error_logs", ["http_code"], name: "index_api_error_logs_on_http_code", using: :btree

  create_table "apn_apps", force: true do |t|
    t.text     "apn_dev_cert"
    t.text     "apn_prod_cert"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apn_device_groupings", force: true do |t|
    t.integer "group_id"
    t.integer "device_id"
  end

  add_index "apn_device_groupings", ["device_id"], name: "index_apn_device_groupings_on_device_id", using: :btree
  add_index "apn_device_groupings", ["group_id", "device_id"], name: "index_apn_device_groupings_on_group_id_and_device_id", using: :btree
  add_index "apn_device_groupings", ["group_id"], name: "index_apn_device_groupings_on_group_id", using: :btree

  create_table "apn_devices", force: true do |t|
    t.string   "token",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
    t.datetime "last_registered_at"
  end

  add_index "apn_devices", ["token"], name: "index_apn_devices_on_token", using: :btree

  create_table "apn_group_notifications", force: true do |t|
    t.integer  "group_id",          null: false
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apn_group_notifications", ["group_id"], name: "index_apn_group_notifications_on_group_id", using: :btree

  create_table "apn_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  create_table "apn_notifications", force: true do |t|
    t.integer  "device_id",                     null: false
    t.integer  "errors_nb",         default: 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "custom_properties"
  end

  add_index "apn_notifications", ["device_id"], name: "index_apn_notifications_on_device_id", using: :btree

  create_table "apn_pull_notifications", force: true do |t|
    t.integer  "app_id"
    t.string   "title"
    t.string   "content"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "launch_notification"
  end

  create_table "calendar_days", force: true do |t|
    t.integer  "patient_id"
    t.date     "date"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "rescue_inhaler_use_count", default: 0
    t.string   "asthma_attack_severity"
    t.text     "conditions"
    t.string   "activity_level"
    t.text     "trigger_ids"
    t.text     "notes"
    t.boolean  "questionaire_alert"
  end

  add_index "calendar_days", ["patient_id", "date"], name: "index_calendar_days_on_patient_id_and_date", unique: true, using: :btree

  create_table "case_managers", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "organization_id",                 null: false
    t.boolean  "is_supervisor",   default: false, null: false
    t.boolean  "is_admin",        default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "deleted_at"
  end

  create_table "case_managers_codes", id: false, force: true do |t|
    t.integer "case_manager_id"
    t.integer "code_id"
  end

  add_index "case_managers_codes", ["case_manager_id"], name: "index_case_managers_codes_on_case_manager_id", using: :btree
  add_index "case_managers_codes", ["code_id"], name: "index_case_managers_codes_on_code_id", using: :btree

  create_table "chirp_subscriptions", force: true do |t|
    t.integer  "patient_id"
    t.integer  "time_to_notify", default: 16
    t.boolean  "enabled",        default: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "chirp_tags", force: true do |t|
    t.integer  "chirp_id",                   null: false
    t.integer  "tag_id",                     null: false
    t.boolean  "suppress",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "chirp_tags", ["chirp_id"], name: "index_chirp_tags_on_chirp_id", using: :btree
  add_index "chirp_tags", ["tag_id"], name: "index_chirp_tags_on_tag_id", using: :btree

  create_table "chirp_translations", force: true do |t|
    t.integer  "chirp_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "message"
  end

  add_index "chirp_translations", ["chirp_id"], name: "index_chirp_translations_on_chirp_id", using: :btree
  add_index "chirp_translations", ["locale"], name: "index_chirp_translations_on_locale", using: :btree

  create_table "chirps", force: true do |t|
    t.text     "intent"
    t.text     "content_code"
    t.boolean  "universal",    default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "client_service_nudges", force: true do |t|
    t.string   "name"
    t.string   "message"
    t.string   "intent"
    t.boolean  "is_active",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "code_custom_nudges", force: true do |t|
    t.string   "name"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "code_custom_nudges_codes", force: true do |t|
    t.integer "code_id"
    t.integer "code_custom_nudge_id"
  end

  add_index "code_custom_nudges_codes", ["code_custom_nudge_id"], name: "index_code_custom_nudges_codes_on_code_custom_nudge_id", using: :btree
  add_index "code_custom_nudges_codes", ["code_id"], name: "index_code_custom_nudges_codes_on_code_id", using: :btree

  create_table "code_custom_symptoms", force: true do |t|
    t.integer  "code_id"
    t.integer  "custom_symptom_id"
    t.integer  "sort_order"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "code_custom_symptoms", ["code_id"], name: "index_code_custom_symptoms_on_code_id", using: :btree
  add_index "code_custom_symptoms", ["custom_symptom_id"], name: "index_code_custom_symptoms_on_custom_symptom_id", using: :btree

  create_table "code_custom_triggers", force: true do |t|
    t.integer  "code_id"
    t.integer  "custom_trigger_id"
    t.integer  "sort_order"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "code_custom_triggers", ["code_id"], name: "index_code_custom_triggers_on_code_id", using: :btree
  add_index "code_custom_triggers", ["custom_trigger_id"], name: "index_code_custom_triggers_on_custom_trigger_id", using: :btree

  create_table "code_features", force: true do |t|
    t.integer  "code_id",    null: false
    t.integer  "feature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sort_order"
  end

  add_index "code_features", ["code_id"], name: "index_code_features_on_code_id", using: :btree
  add_index "code_features", ["feature_id"], name: "index_code_features_on_feature_id", using: :btree

  create_table "code_measurement_suppressions", force: true do |t|
    t.integer  "code_id"
    t.integer  "measurement_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "code_measurement_suppressions", ["code_id", "measurement_id"], name: "index_code_measurement_suppressions_on_unique", unique: true, using: :btree
  add_index "code_measurement_suppressions", ["code_id"], name: "index_code_measurement_suppressions_on_code_id", using: :btree
  add_index "code_measurement_suppressions", ["measurement_id"], name: "index_code_measurement_suppressions_on_measurement_id", using: :btree

  create_table "code_measurements", force: true do |t|
    t.integer  "code_id"
    t.integer  "measurement_id"
    t.boolean  "measurement_removable", default: false
    t.boolean  "default_measurement",   default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "deleted_at"
    t.integer  "sort_order"
  end

  create_table "code_symptom_suppressions", force: true do |t|
    t.integer  "code_id"
    t.integer  "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "code_symptom_suppressions", ["code_id", "symptom_id"], name: "index_code_symptom_suppressions_on_unique", unique: true, using: :btree
  add_index "code_symptom_suppressions", ["code_id"], name: "index_code_symptom_suppressions_on_code_id", using: :btree
  add_index "code_symptom_suppressions", ["symptom_id"], name: "index_code_symptom_suppressions_on_symptom_id", using: :btree

  create_table "code_symptoms", force: true do |t|
    t.integer  "symptom_id",                null: false
    t.integer  "code_id",                   null: false
    t.boolean  "include",    default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
  end

  add_index "code_symptoms", ["code_id"], name: "index_code_symptoms_on_code_id", using: :btree
  add_index "code_symptoms", ["symptom_id"], name: "index_code_symptoms_on_symptom_id", using: :btree

  create_table "code_tracks", force: true do |t|
    t.integer  "code_id"
    t.integer  "condition_id"
    t.boolean  "checked_by_default"
    t.boolean  "uncheckable"
    t.integer  "sort_order"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "code_tracks", ["code_id", "condition_id"], name: "index_code_tracks_on_code_id_and_condition_id", unique: true, using: :btree
  add_index "code_tracks", ["code_id"], name: "index_code_tracks_on_code_id", using: :btree
  add_index "code_tracks", ["condition_id"], name: "index_code_tracks_on_condition_id", using: :btree

  create_table "codes", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "max_number"
    t.text     "terms_and_conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "condition_id"
    t.text     "additional_message"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "organization_id"
    t.boolean  "use_custom_triggers",         default: false
    t.boolean  "use_custom_symptoms",         default: false
    t.boolean  "points_is_visible",           default: true
    t.boolean  "nudges_active",               default: false
    t.boolean  "use_custom_nudges",           default: false
    t.boolean  "use_ad_hoc_nudges",           default: false
    t.boolean  "allow_client_service_nudges", default: true
    t.boolean  "is_case_manager_indicator",   default: false
    t.datetime "deleted_at"
  end

  create_table "condition_measurements", force: true do |t|
    t.integer  "condition_id"
    t.integer  "measurement_id"
    t.boolean  "measurement_removable", default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "deleted_at"
    t.boolean  "default_measurement"
    t.integer  "sort_order"
  end

  add_index "condition_measurements", ["condition_id", "measurement_id"], name: "index_condition_measurements_on_condition_id_and_measurement_id", unique: true, using: :btree
  add_index "condition_measurements", ["condition_id"], name: "index_condition_measurements_on_condition_id", using: :btree
  add_index "condition_measurements", ["measurement_id"], name: "index_condition_measurements_on_measurement_id", using: :btree

  create_table "condition_translations", force: true do |t|
    t.integer  "condition_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "display_name"
  end

  add_index "condition_translations", ["condition_id"], name: "index_condition_translations_on_condition_id", using: :btree
  add_index "condition_translations", ["locale"], name: "index_condition_translations_on_locale", using: :btree

  create_table "conditions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_guide_file_name"
    t.boolean  "refill_reminder",      default: true
    t.boolean  "weather",              default: true
    t.integer  "default_game_choice"
    t.boolean  "is_track",             default: true
    t.boolean  "track_uncheckable",    default: true
    t.integer  "track_sort_order",     default: 21
    t.string   "display_name"
    t.integer  "parent_id"
    t.datetime "deleted_at"
  end

  add_index "conditions", ["parent_id"], name: "index_conditions_on_parent_id", using: :btree

  create_table "custom_symptoms", force: true do |t|
    t.string   "name"
    t.boolean  "include",    default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "custom_triggers", force: true do |t|
    t.string   "name"
    t.boolean  "include",    default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "demographic_answers", force: true do |t|
    t.integer  "demographic_question_id"
    t.integer  "user_id"
    t.string   "content"
    t.string   "question_copy"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "demographic_questions", force: true do |t|
    t.integer  "code_id"
    t.boolean  "required"
    t.boolean  "include"
    t.text     "label"
    t.text     "help_text"
    t.integer  "max_characters"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "sort_order"
    t.boolean  "include_dashboard", default: false
  end

  create_table "documents", force: true do |t|
    t.string   "title"
    t.integer  "condition_id"
    t.integer  "code_id"
    t.integer  "language_id"
    t.string   "document_file_name"
    t.integer  "document_file_size"
    t.string   "document_content_type"
    t.datetime "document_updated_at"
    t.integer  "order_id"
    t.string   "classification"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "dose_alarms", force: true do |t|
    t.integer  "dose_id"
    t.integer  "measurement_source_id"
    t.boolean  "enabled"
    t.time     "weekday_time"
    t.time     "weekend_time"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "alarm_ids"
  end

  add_index "dose_alarms", ["dose_id"], name: "index_dose_alarms_on_dose_id", using: :btree
  add_index "dose_alarms", ["measurement_source_id"], name: "index_dose_alarms_on_measurement_source_id", using: :btree

  create_table "doses", force: true do |t|
    t.integer  "prescription_id"
    t.string   "time_window"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
    t.string   "type"
  end

  add_index "doses", ["prescription_id", "created_at"], name: "index_doses_on_prescription_id_and_created_at", using: :btree

  create_table "features", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foreign_user_accounts", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.string   "empi_number",     null: false
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "foreign_user_accounts", ["empi_number"], name: "index_foreign_user_accounts_on_empi_number", unique: true, using: :btree

  create_table "game_consumed_time_windows", force: true do |t|
    t.integer  "calendar_day_id"
    t.string   "window_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "game_consumed_time_windows", ["calendar_day_id"], name: "index_game_consumed_time_windows_on_calendar_day_id", using: :btree

  create_table "game_states", force: true do |t|
    t.integer  "patient_id"
    t.text     "abriizling_data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "cardling_data"
  end

  add_index "game_states", ["patient_id"], name: "index_game_states_on_patient_id", using: :btree

  create_table "gcm_devices", force: true do |t|
    t.string   "registration_id",    null: false
    t.datetime "last_registered_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "gcm_devices", ["registration_id"], name: "index_gcm_devices_on_registration_id", unique: true, using: :btree

  create_table "gcm_notifications", force: true do |t|
    t.integer  "device_id",        null: false
    t.string   "collapse_key"
    t.text     "data"
    t.boolean  "delay_while_idle"
    t.datetime "sent_at"
    t.integer  "time_to_live"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "gcm_notifications", ["device_id"], name: "index_gcm_notifications_on_device_id", using: :btree

  create_table "goals", force: true do |t|
    t.date     "end_at"
    t.text     "reward"
    t.integer  "patient_id"
    t.string   "period"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "notified_of_completion",             default: false
    t.date     "start_at"
    t.boolean  "allow_restart",                      default: false
    t.integer  "restart_count",                      default: 0
    t.string   "type",                   limit: 100,                 null: false
    t.integer  "total_points"
    t.integer  "target_points"
  end

  create_table "group_codes", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "max_number"
    t.text     "terms_and_conditions"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "invitation_types", force: true do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "invitations", force: true do |t|
    t.string   "recipient"
    t.string   "state",                        default: "pending"
    t.integer  "access_level"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "patient_id"
    t.text     "personal_message"
    t.string   "token"
    t.integer  "invitation_type_id",                               null: false
    t.integer  "code_id"
    t.string   "patient_first_name"
    t.string   "patient_last_name"
    t.date     "patient_dob"
    t.text     "track_ids"
    t.string   "patient_gender",     limit: 1
    t.boolean  "patient_is_user"
    t.string   "user_email"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_address"
    t.string   "user_city"
    t.string   "user_state"
    t.string   "user_zip_code"
    t.string   "user_home_phone"
    t.string   "user_mobile_phone"
    t.string   "user_alt_phone"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "links", force: true do |t|
    t.string   "title"
    t.integer  "condition_id"
    t.integer  "code_id"
    t.integer  "language_id"
    t.string   "url"
    t.integer  "order_id"
    t.string   "classification"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "measurement_context_translations", force: true do |t|
    t.integer  "measurement_context_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "measurement_context_translations", ["locale"], name: "index_measurement_context_translations_on_locale", using: :btree
  add_index "measurement_context_translations", ["measurement_context_id"], name: "index_60245ba9cad7b40648def3541af11af2db50b8dc", using: :btree

  create_table "measurement_contexts", force: true do |t|
    t.integer  "measurement_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
  end

  add_index "measurement_contexts", ["measurement_id"], name: "index_measurement_contexts_on_measurement_id", using: :btree

  create_table "measurement_list_configuration_translations", force: true do |t|
    t.integer  "measurement_list_configuration_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "measurement_list_configuration_translations", ["locale"], name: "index_measurement_list_configuration_translations_on_locale", using: :btree
  add_index "measurement_list_configuration_translations", ["measurement_list_configuration_id"], name: "index_871fd9ae2eef4013396f597d7bbc44ce7b47eff9", using: :btree

  create_table "measurement_list_configurations", force: true do |t|
    t.string   "name"
    t.integer  "measurement_id"
    t.boolean  "measurement_value"
    t.boolean  "measurement_target_minus_measurement_value"
    t.boolean  "measurement_change"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "max_value"
    t.boolean  "min_value"
    t.boolean  "measurement_range"
    t.boolean  "measurement_count"
  end

  create_table "measurement_list_configurations_patient_list_configurations", id: false, force: true do |t|
    t.integer "measurement_list_configuration_id"
    t.integer "patient_list_configuration_id"
  end

  create_table "measurement_pairs", force: true do |t|
    t.integer "measurement_id"
    t.integer "paired_measurement_id"
  end

  create_table "measurement_recordings", force: true do |t|
    t.string   "value"
    t.integer  "patient_measurement_id"
    t.integer  "calendar_day_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "patient_measurement_context_id"
    t.integer  "patient_custom_measurement_id"
    t.integer  "patient_custom_measurement_context_id"
  end

  add_index "measurement_recordings", ["calendar_day_id"], name: "index_measurement_recordings_on_calendar_day_id", using: :btree
  add_index "measurement_recordings", ["patient_custom_measurement_context_id"], name: "index_recordings_on_custom_measurement_context_id", using: :btree
  add_index "measurement_recordings", ["patient_custom_measurement_id"], name: "index_recordings_on_patient_custom_measurement_id", using: :btree
  add_index "measurement_recordings", ["patient_measurement_context_id"], name: "index_measurement_recordings_on_patient_measurement_context_id", using: :btree
  add_index "measurement_recordings", ["patient_measurement_id"], name: "index_measurement_recordings_on_patient_measurement_id", using: :btree

  create_table "measurement_source_mappings", force: true do |t|
    t.integer  "measurement_id"
    t.integer  "measurement_source_id"
    t.string   "measurement_alias"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "measurement_source_mappings", ["measurement_id"], name: "index_measurement_source_mappings_on_measurement_id", using: :btree
  add_index "measurement_source_mappings", ["measurement_source_id"], name: "index_measurement_source_mappings_on_measurement_source_id", using: :btree

  create_table "measurement_sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
  end

  create_table "measurement_targets", force: true do |t|
    t.integer  "patient_measurement_id"
    t.string   "value"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "patient_custom_measurement_id"
  end

  add_index "measurement_targets", ["patient_custom_measurement_id"], name: "index_targets_on_patient_custom_measurement_id", using: :btree
  add_index "measurement_targets", ["patient_measurement_id"], name: "index_measurement_targets_on_patient_measurement_id", unique: true, using: :btree

  create_table "measurement_translations", force: true do |t|
    t.integer  "measurement_id"
    t.string   "locale"
    t.string   "name"
    t.string   "unit"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "fractional_numerator_label"
    t.string   "fractional_denominator_label"
    t.string   "delta_label"
  end

  add_index "measurement_translations", ["locale"], name: "index_measurement_translations_on_locale", using: :btree
  add_index "measurement_translations", ["measurement_id"], name: "index_measurement_translations_on_measurement_id", using: :btree

  create_table "measurements", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.string   "format_style"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
  end

  create_table "message_logs", force: true do |t|
    t.string   "mechanism"
    t.string   "sender_ref"
    t.string   "recipient"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "missed_dose_notifications", force: true do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "patient_privilege_id"
    t.integer  "missed_dose_threshold", default: 2
    t.boolean  "email"
    t.boolean  "sms"
  end

  create_table "missed_doses", force: true do |t|
    t.integer  "calendar_day_id"
    t.integer  "dose_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "missed_doses", ["calendar_day_id", "dose_id"], name: "index_missed_doses_on_calendar_day_id_and_dose_id", unique: true, using: :btree

  create_table "non_empty_calendar_days", force: true do |t|
    t.integer  "patient_id"
    t.integer  "calendar_day_id"
    t.date     "date"
    t.integer  "rescue_inhaler_use_count", default: 0
    t.string   "asthma_attack_severity"
    t.text     "conditions"
    t.string   "activity_level"
    t.text     "trigger_ids"
    t.text     "notes"
    t.boolean  "questionaire_alert"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "notification_recordings", force: true do |t|
    t.string   "message"
    t.integer  "patient_id"
    t.integer  "chirp_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "scheduled_message_id"
  end

  add_index "notification_recordings", ["chirp_id"], name: "index_notification_recordings_on_chirp_id", using: :btree
  add_index "notification_recordings", ["patient_id"], name: "index_notification_recordings_on_patient_id", using: :btree

  create_table "nudge_recordings", force: true do |t|
    t.text     "message"
    t.datetime "sent_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "patient_id"
    t.string   "nudger_type"
    t.integer  "nudger_id"
    t.datetime "acknowledged_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "api_client_id"
  end

  create_table "patient_attachments", force: true do |t|
    t.integer  "patient_id"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.text     "comment"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "patient_custom_measurement_contexts", force: true do |t|
    t.string   "name"
    t.integer  "patient_custom_measurement_id"
    t.integer  "patient_measurement_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
  end

  add_index "patient_custom_measurement_contexts", ["patient_custom_measurement_id"], name: "index_patient_custom_contexts_on_custom_measurement_id", using: :btree
  add_index "patient_custom_measurement_contexts", ["patient_measurement_id"], name: "index_patient_custom_contexts_on_patient_measurement_id", using: :btree

  create_table "patient_custom_measurements", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.string   "format_style"
    t.integer  "patient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
  end

  add_index "patient_custom_measurements", ["patient_id"], name: "index_patient_custom_measurements_on_patient_id", using: :btree

  create_table "patient_links", force: true do |t|
    t.integer  "patient_id"
    t.text     "url"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient_list_configurations", force: true do |t|
    t.integer  "condition_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "patient_list_configurations_patient_list_metrics", id: false, force: true do |t|
    t.integer "patient_list_configuration_id"
    t.integer "patient_list_metric_id"
  end

  create_table "patient_list_metrics", force: true do |t|
    t.string "name"
  end

  create_table "patient_measurement_contexts", force: true do |t|
    t.integer  "measurement_context_id"
    t.integer  "patient_measurement_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "patient_measurement_contexts", ["measurement_context_id"], name: "index_patient_measurement_contexts_on_measurement_context_id", using: :btree
  add_index "patient_measurement_contexts", ["patient_measurement_id"], name: "index_patient_measurement_contexts_on_patient_measurement_id", using: :btree

  create_table "patient_measurement_sources", force: true do |t|
    t.integer  "patient_id"
    t.integer  "measurement_source_id"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "device_id"
    t.datetime "last_sync"
  end

  add_index "patient_measurement_sources", ["measurement_source_id"], name: "index_patient_measurement_sources_on_measurement_source_id", using: :btree
  add_index "patient_measurement_sources", ["patient_id"], name: "index_patient_measurement_sources_on_patient_id", using: :btree

  create_table "patient_measurements", force: true do |t|
    t.integer  "patient_id"
    t.integer  "measurement_id"
    t.integer  "measurement_source_id"
    t.datetime "deleted_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "patient_measurements", ["measurement_id"], name: "index_patient_measurements_on_measurement_id", using: :btree
  add_index "patient_measurements", ["measurement_source_id"], name: "index_patient_measurements_on_measurement_source_id", using: :btree
  add_index "patient_measurements", ["patient_id", "measurement_id"], name: "index_patient_measurements_on_patient_id_and_measurement_id", unique: true, using: :btree
  add_index "patient_measurements", ["patient_id", "measurement_id"], name: "unique_index_on_patient_id_and_measurement_id", unique: true, using: :btree
  add_index "patient_measurements", ["patient_id"], name: "index_patient_measurements_on_patient_id", using: :btree

  create_table "patient_privileges", force: true do |t|
    t.integer  "user_id"
    t.integer  "patient_id"
    t.string   "type",          default: "PatientPrivilege::Owner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.datetime "deleted_at"
  end

  add_index "patient_privileges", ["user_id", "patient_id"], name: "index_patient_privileges_on_user_id_and_patient_id", using: :btree

  create_table "patient_symptoms", force: true do |t|
    t.integer  "patient_id",             null: false
    t.integer  "symptom_id",             null: false
    t.integer  "sort_order", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "patient_symptoms", ["patient_id"], name: "index_patient_symptoms_on_patient_id", using: :btree
  add_index "patient_symptoms", ["symptom_id"], name: "index_patient_symptoms_on_symptom_id", using: :btree

  create_table "patient_tags", force: true do |t|
    t.integer  "patient_id", null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "patient_tags", ["patient_id"], name: "index_patient_tags_on_patient_id", using: :btree
  add_index "patient_tags", ["tag_id"], name: "index_patient_tags_on_tag_id", using: :btree

  create_table "patient_tracks", force: true do |t|
    t.integer  "patient_id"
    t.integer  "condition_id"
    t.boolean  "is_primary",   default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "patient_triggers", force: true do |t|
    t.string   "name"
    t.boolean  "enabled",     default: true, null: false
    t.integer  "patient_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "sort_number", default: 0
  end

  add_index "patient_triggers", ["patient_id", "created_at"], name: "index_patient_triggers_on_patient_id_and_created_at", using: :btree

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.integer  "user_id"
    t.string   "access_code"
    t.integer  "mobile_id"
    t.string   "device_token"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "last_sync"
    t.string   "timezone",                           default: "Eastern Time (US & Canada)"
    t.boolean  "active",                             default: true
    t.string   "device_type"
    t.text     "note"
    t.datetime "note_updated_at"
    t.datetime "last_questionaire_fetch_attempt_at"
    t.boolean  "can_share_abriizlings",              default: true
    t.string   "unique_hash",                                                               null: false
    t.boolean  "weather_enabled",                    default: true
    t.boolean  "allow_change_i_will_i_may",          default: true
    t.integer  "game_choice"
    t.datetime "deleted_at"
  end

  add_index "patients", ["user_id"], name: "index_patients_on_user_id", using: :btree

  create_table "point_states", force: true do |t|
    t.integer  "patient_id"
    t.integer  "total_points"
    t.boolean  "show_messages",           default: true
    t.boolean  "is_branded",              default: true
    t.datetime "last_sync"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "accumulated_game_points"
  end

  add_index "point_states", ["patient_id"], name: "index_point_states_on_patient_id", using: :btree

  create_table "prescriptions", force: true do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name"
    t.integer  "patient_id"
    t.datetime "deleted_at"
    t.integer  "sort_number", default: 0
  end

  add_index "prescriptions", ["patient_id", "name"], name: "index_prescriptions_on_patient_id_and_name", using: :btree

  create_table "questionaire_questions", force: true do |t|
    t.integer  "questionaire_id"
    t.text     "title"
    t.string   "style"
    t.integer  "sku"
    t.integer  "order"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "questionaire_questions", ["questionaire_id"], name: "index_questionaire_questions_on_questionaire_id", using: :btree

  create_table "questionaire_responses", force: true do |t|
    t.integer  "calendar_day_id"
    t.integer  "patient_id"
    t.integer  "questionaire_question_id"
    t.text     "answer"
    t.integer  "sku"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "questionaire_responses", ["calendar_day_id"], name: "index_questionaire_responses_on_calendar_day_id", using: :btree
  add_index "questionaire_responses", ["patient_id"], name: "index_questionaire_responses_on_patient_id", using: :btree
  add_index "questionaire_responses", ["questionaire_question_id"], name: "index_questionaire_responses_on_questionaire_question_id", using: :btree

  create_table "questionaires", force: true do |t|
    t.string   "title"
    t.integer  "code_id"
    t.text     "link"
    t.time     "time_to_notify"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "status"
    t.integer  "sku"
    t.string   "gizmo_username"
    t.string   "gizmo_password"
    t.datetime "invalidated_at"
  end

  add_index "questionaires", ["code_id"], name: "index_questionaires_on_code_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month"
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "refill_reminders", force: true do |t|
    t.integer  "patient_privilege_id"
    t.integer  "threshold",            default: 30
    t.date     "start_date"
    t.boolean  "sms",                  default: false
    t.boolean  "email",                default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "code",        null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "scheduled_message_tags", force: true do |t|
    t.integer  "scheduled_message_id",                 null: false
    t.integer  "tag_id",                               null: false
    t.boolean  "suppress",             default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "scheduled_message_tags", ["scheduled_message_id"], name: "index_scheduled_message_tags_on_scheduled_message_id", using: :btree
  add_index "scheduled_message_tags", ["tag_id"], name: "index_scheduled_message_tags_on_tag_id", using: :btree

  create_table "scheduled_message_translations", force: true do |t|
    t.integer  "scheduled_message_id", null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "message"
  end

  add_index "scheduled_message_translations", ["locale"], name: "index_scheduled_message_translations_on_locale", using: :btree
  add_index "scheduled_message_translations", ["scheduled_message_id"], name: "index_scheduled_message_translations_on_scheduled_message_id", using: :btree

  create_table "scheduled_messages", force: true do |t|
    t.date     "send_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sms_subscriptions", force: true do |t|
    t.boolean  "missed_dose_notifications_sms", default: false
    t.string   "sms_number"
    t.boolean  "has_opted_in",                  default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "patient_privilege_id"
  end

  create_table "subscriptions", force: true do |t|
    t.string  "type"
    t.integer "user_id", null: false
    t.integer "code_id"
  end

  create_table "symptom_recordings", force: true do |t|
    t.integer  "calendar_day_id",    null: false
    t.integer  "patient_symptom_id", null: false
    t.datetime "experienced_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "symptom_recordings", ["calendar_day_id"], name: "index_symptom_recordings_on_calendar_day_id", using: :btree
  add_index "symptom_recordings", ["patient_symptom_id"], name: "index_symptom_recordings_on_patient_symptom_id", using: :btree

  create_table "symptoms", force: true do |t|
    t.string   "name",                      null: false
    t.boolean  "is_canned",  default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "symptoms", ["name"], name: "index_symptoms_on_name", using: :btree

  create_table "tag_categories", force: true do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tags", force: true do |t|
    t.string   "description"
    t.integer  "tag_category_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tags", ["tag_category_id"], name: "index_tags_on_tag_category_id", using: :btree

  create_table "taken_as_needed_doses", force: true do |t|
    t.integer  "as_needed_id"
    t.integer  "dose_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "calendar_day_id"
  end

  create_table "taken_doses", force: true do |t|
    t.integer  "calendar_day_id"
    t.integer  "dose_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "taken_doses", ["calendar_day_id", "dose_id"], name: "index_taken_doses_on_calendar_day_id_and_dose_id", unique: true, using: :btree

  create_table "track_symptoms", force: true do |t|
    t.integer  "symptom_id",                        null: false
    t.integer  "condition_id",                      null: false
    t.boolean  "old_style_trigger", default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "deleted_at"
  end

  add_index "track_symptoms", ["condition_id"], name: "index_track_symptoms_on_condition_id", using: :btree
  add_index "track_symptoms", ["symptom_id"], name: "index_track_symptoms_on_symptom_id", using: :btree

  create_table "trend_graph_configurations", force: true do |t|
    t.text     "name"
    t.integer  "condition_id"
    t.boolean  "scheduled_doses"
    t.boolean  "rescue_doses"
    t.boolean  "taken_doses"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "trend_graph_configurations", ["condition_id"], name: "index_plots_on_condition_id", using: :btree

  create_table "trend_graph_measurement_configuration_translations", force: true do |t|
    t.integer  "trend_graph_measurement_configuration_id"
    t.string   "locale"
    t.string   "title"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "numerator_label"
    t.string   "denominator_label"
  end

  add_index "trend_graph_measurement_configuration_translations", ["locale"], name: "index_dd68f4d4e91bd25a4b2a2dd438e8f52e204a8fe2", using: :btree
  add_index "trend_graph_measurement_configuration_translations", ["trend_graph_measurement_configuration_id"], name: "index_1dc8f8dce62a9af893d6ad6f4237f5c776f2f7ce", using: :btree

  create_table "trend_graph_measurement_configurations", force: true do |t|
    t.integer  "measurement_id"
    t.string   "title"
    t.boolean  "target_variations"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "numerator_label"
    t.string   "denominator_label"
  end

  add_index "trend_graph_measurement_configurations", ["measurement_id"], name: "index_trend_graph_measurement_configurations_on_measurement_id", using: :btree

  create_table "trial_requests", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "user_type"
    t.string   "referred_by"
    t.string   "insurance_access"
    t.string   "insurance_provider"
    t.text     "additional_comments"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "condition_id"
  end

  create_table "triggers", force: true do |t|
    t.integer  "patient_trigger_id"
    t.integer  "calendar_day_id"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "triggers", ["calendar_day_id"], name: "index_triggers_on_calendar_day_id", using: :btree
  add_index "triggers", ["patient_trigger_id"], name: "index_triggers_on_patient_trigger_id", using: :btree

  create_table "user_invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "invitation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                                     default: "",    null: false
    t.string   "encrypted_password",            limit: 128, default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "username"
    t.string   "zip_code"
    t.string   "display_username"
    t.string   "display_email"
    t.integer  "last_viewed_patient_id"
    t.integer  "condition_id"
    t.string   "mobile_phone"
    t.boolean  "sms_confirmation",                          default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "home_phone"
    t.string   "alt_phone"
    t.boolean  "legacy",                                    default: false
    t.boolean  "can_receive_abriizlings",                   default: true
    t.string   "authentication_token",                      default: "",    null: false
    t.datetime "authentication_token_reset_at"
    t.integer  "failed_attempts",                           default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "logout_state"
    t.string   "uid"
    t.datetime "deleted_at"
    t.boolean  "dont_show_mobile_pin_popup"
  end

  add_index "users", ["email"], name: "unique_email_constraint", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "vimeo_id"
    t.integer  "condition_id"
    t.integer  "language_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "thumbnail_url"
    t.integer  "order_id"
    t.string   "classification"
    t.integer  "code_id"
  end

  create_table "weathers", force: true do |t|
    t.string   "zip_code"
    t.integer  "temperature"
    t.string   "current_condition"
    t.date     "date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "high"
    t.integer  "low"
    t.string   "forecast_condition"
  end

  add_index "weathers", ["date"], name: "index_weathers_on_date", using: :btree
  add_index "weathers", ["zip_code"], name: "index_weathers_on_zip_code", using: :btree

  add_foreign_key "access_tokens", "patients", name: "access_tokens_patient_id_fk"

  add_foreign_key "alert_occurrences", "alerts", name: "alert_occurrences_alert_id_fk"
  add_foreign_key "alert_occurrences", "patients", name: "alert_occurrences_patient_id_fk"

  add_foreign_key "alerts", "alert_categories", name: "alerts_alert_category_id_fk"
  add_foreign_key "alerts", "measurements", name: "alerts_measurement_id_fk"
  add_foreign_key "alerts", "patient_custom_measurements", name: "alerts_patient_custom_measurement_id_fk"
  add_foreign_key "alerts", "patients", name: "alerts_patient_id_fk"
  add_foreign_key "alerts", "users", name: "alerts_user_id_fk"

  add_foreign_key "api_client_roles", "api_clients", name: "api_client_roles_api_client_id_fk"
  add_foreign_key "api_client_roles", "roles", name: "api_client_roles_role_id_fk"

  add_foreign_key "chirp_tags", "chirps", name: "chirp_tags_chirp_id_fk"
  add_foreign_key "chirp_tags", "tags", name: "chirp_tags_tag_id_fk"

  add_foreign_key "code_custom_nudges_codes", "code_custom_nudges", name: "code_custom_nudges_codes_code_custom_nudge_id_fk"
  add_foreign_key "code_custom_nudges_codes", "codes", name: "code_custom_nudges_codes_code_id_fk"

  add_foreign_key "code_features", "codes", name: "code_features_code_id_fk"
  add_foreign_key "code_features", "features", name: "code_features_feature_id_fk"

  add_foreign_key "code_measurement_suppressions", "codes", name: "code_measurement_suppressions_code_id_fk"
  add_foreign_key "code_measurement_suppressions", "measurements", name: "code_measurement_suppressions_measurement_id_fk"

  add_foreign_key "code_measurements", "codes", name: "code_measurements_code_id_fk"
  add_foreign_key "code_measurements", "measurements", name: "code_measurements_measurement_id_fk"

  add_foreign_key "code_symptom_suppressions", "codes", name: "code_symptom_suppressions_code_id_fk"
  add_foreign_key "code_symptom_suppressions", "symptoms", name: "code_symptom_suppressions_symptom_id_fk"

  add_foreign_key "code_symptoms", "codes", name: "code_symptoms_code_id_fk"
  add_foreign_key "code_symptoms", "symptoms", name: "code_symptoms_symptom_id_fk"

  add_foreign_key "code_tracks", "codes", name: "code_tracks_code_id_fk"
  add_foreign_key "code_tracks", "conditions", name: "code_tracks_condition_id_fk"

  add_foreign_key "codes", "organizations", name: "codes_organization_id_fk"

  add_foreign_key "foreign_user_accounts", "organizations", name: "foreign_user_accounts_organization_id_fk"
  add_foreign_key "foreign_user_accounts", "users", name: "foreign_user_accounts_user_id_fk"

  add_foreign_key "invitations", "codes", name: "invitations_code_id_fk"
  add_foreign_key "invitations", "invitation_types", name: "invitations_invitation_type_id_fk"

  add_foreign_key "notification_recordings", "patients", name: "notification_recordings_patient_id_fk"

  add_foreign_key "patient_symptoms", "patients", name: "patient_symptoms_patient_id_fk"
  add_foreign_key "patient_symptoms", "symptoms", name: "patient_symptoms_symptom_id_fk"

  add_foreign_key "patient_tags", "patients", name: "patient_tags_patient_id_fk"
  add_foreign_key "patient_tags", "tags", name: "patient_tags_tag_id_fk"

  add_foreign_key "patient_tracks", "conditions", name: "patient_tracks_condition_id_fk"
  add_foreign_key "patient_tracks", "patients", name: "patient_tracks_patient_id_fk"

  add_foreign_key "point_states", "patients", name: "point_states_patient_id_fk"

  add_foreign_key "scheduled_message_tags", "scheduled_messages", name: "scheduled_message_tags_scheduled_message_id_fk"
  add_foreign_key "scheduled_message_tags", "tags", name: "scheduled_message_tags_tag_id_fk"

  add_foreign_key "symptom_recordings", "calendar_days", name: "symptom_recordings_calendar_day_id_fk"
  add_foreign_key "symptom_recordings", "patient_symptoms", name: "symptom_recordings_patient_symptom_id_fk"

  add_foreign_key "tags", "tag_categories", name: "tags_tag_category_id_fk"

  add_foreign_key "track_symptoms", "conditions", name: "track_symptoms_condition_id_fk"
  add_foreign_key "track_symptoms", "symptoms", name: "track_symptoms_symptom_id_fk"

end
