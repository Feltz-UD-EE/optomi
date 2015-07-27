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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150521211828) do

  create_table "admins", :force => true do |t|
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "role"
    t.boolean  "twilio_access"
    t.integer  "boss_id"
    t.integer  "organization_id"
    t.integer  "user_id",         :null => false
  end

  create_table "assessment_answers", :force => true do |t|
    t.integer  "possible_answer_id", :null => false
    t.integer  "assessment_id",      :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "assessments", :force => true do |t|
    t.string   "patient_name",         :null => false
    t.integer  "patient_age",          :null => false
    t.boolean  "referral"
    t.decimal  "alos_raw"
    t.integer  "alos_percentile"
    t.decimal  "majcomp_raw"
    t.integer  "majcomp_percentile"
    t.decimal  "morbidity_raw"
    t.integer  "morbidity_percentile"
    t.integer  "risk_calculated"
    t.integer  "risk_adjusted"
    t.integer  "admin_id",             :null => false
    t.integer  "patient_id"
    t.integer  "procedure_id",         :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.text     "about",                      :default => ""
    t.text     "disclaimer_short",           :default => ""
    t.text     "disclaimer_long",            :default => ""
    t.text     "privacy_short",              :default => ""
    t.text     "privacy_long",               :default => ""
    t.boolean  "privacy_use_both_flag"
    t.text     "additional_content",         :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_internal_file_name"
    t.string   "logo_internal_content_type"
    t.integer  "logo_internal_file_size"
    t.datetime "logo_internal_updated_at"
    t.string   "logo_external_file_name"
    t.string   "logo_external_content_type"
    t.integer  "logo_external_file_size"
    t.datetime "logo_external_updated_at"
  end

  create_table "equation_cutoffs", :force => true do |t|
    t.integer  "equation_id", :null => false
    t.integer  "percentile",  :null => false
    t.decimal  "value",       :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "equation_lines", :force => true do |t|
    t.string   "name",               :null => false
    t.decimal  "coeff",              :null => false
    t.integer  "equation_id",        :null => false
    t.integer  "possible_answer_id", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "equations", :force => true do |t|
    t.decimal  "intercept",     :null => false
    t.decimal  "age_coeff",     :null => false
    t.integer  "procedure_id",  :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "equation_type", :null => false
  end

  create_table "inbound_text_messages", :force => true do |t|
    t.string   "from_phone"
    t.string   "to_phone"
    t.integer  "patient_id"
    t.integer  "prev_outbound_text_id"
    t.text     "contents"
    t.datetime "sent_datetime"
    t.datetime "received_datetime"
    t.integer  "value"
    t.string   "msg_type"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "sms_sid"
    t.string   "status_on_retrieval"
    t.boolean  "from_params"
    t.text     "error_msg"
  end

  create_table "logo_externals", :force => true do |t|
    t.integer "brand_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "logo_internals", :force => true do |t|
    t.integer "brand_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "organization_procedures", :force => true do |t|
    t.integer  "organization_id", :null => false
    t.integer  "procedure_id",    :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "full_name"
    t.string   "short_name"
    t.integer  "medicare_hospital_code"
    t.boolean  "cms_grant"
    t.datetime "created_at",                                                                                  :null => false
    t.datetime "updated_at",                                                                                  :null => false
    t.integer  "brand_id"
    t.string   "contact_name",                 :default => ""
    t.string   "contact_title",                :default => ""
    t.string   "contact_phone",                :default => ""
    t.string   "contact_email",                :default => ""
    t.text     "contact_address",              :default => ""
    t.text     "contact_emergency_disclaimer", :default => "If this is a medical emergency please call 911."
  end

  create_table "outbound_text_messages", :force => true do |t|
    t.string   "from_phone"
    t.string   "to_phone"
    t.integer  "patient_id"
    t.integer  "prev_inbound_text_id"
    t.text     "contents"
    t.datetime "sent_datetime"
    t.datetime "received_datetime"
    t.integer  "value"
    t.string   "msg_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "sms_sid"
  end

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "registration_date"
    t.date     "end_date"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "preferred_contact"
    t.time     "preferred_contact_time"
    t.string   "preferred_contact_day"
    t.integer  "admin_id"
    t.datetime "deleted_at"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "title"
    t.datetime "deactivated_by_user_at"
    t.datetime "reactivated_by_user_at"
    t.date     "spirometer_override_date"
    t.boolean  "spirometer_to_be_used"
    t.boolean  "test_mode"
    t.string   "status"
    t.datetime "status_updated_at"
    t.boolean  "unknown_end_date_flag"
    t.string   "time_zone_str"
    t.integer  "user_id",                  :null => false
  end

  create_table "pedometer_entries", :force => true do |t|
    t.date     "date"
    t.integer  "patient_id"
    t.integer  "steps"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "created_by_admin"
  end

  add_index "pedometer_entries", ["patient_id"], :name => "index_pedometer_entries_on_user_id"

  create_table "phone_polls", :force => true do |t|
    t.integer  "patient_id"
    t.date     "date"
    t.string   "sid"
    t.integer  "pedometer_steps"
    t.integer  "spirometer_breaths"
    t.string   "status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "direction"
    t.datetime "start_datetime"
  end

  add_index "phone_polls", ["patient_id"], :name => "index_phone_polls_on_user_id"

  create_table "possible_answers", :force => true do |t|
    t.string   "value",       :null => false
    t.integer  "question_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "sort_order",  :null => false
    t.boolean  "is_default"
  end

  create_table "procedure_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "sort_order", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "procedures", :force => true do |t|
    t.string   "name",               :null => false
    t.integer  "sort_order",         :null => false
    t.integer  "procedure_group_id", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sort_order", :null => false
    t.string   "short_name"
  end

  create_table "spirometer_entries", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "breaths"
    t.date     "date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "created_by_admin"
  end

  add_index "spirometer_entries", ["patient_id"], :name => "index_spirometer_entries_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  add_foreign_key "admins", "users", name: "admins_user_id_fk"

  add_foreign_key "assessment_answers", "assessments", name: "assessment_answers_assessment_id_fk", dependent: :delete
  add_foreign_key "assessment_answers", "possible_answers", name: "assessment_answers_possible_answer_id_fk", dependent: :delete

  add_foreign_key "assessments", "admins", name: "assessments_admin_id_fk", dependent: :delete
  add_foreign_key "assessments", "patients", name: "assessments_patient_id_fk", dependent: :delete
  add_foreign_key "assessments", "patients", name: "assessments_user_id_fk", dependent: :delete
  add_foreign_key "assessments", "procedures", name: "assessments_procedure_id_fk", dependent: :delete

  add_foreign_key "equation_cutoffs", "equations", name: "equation_cutoffs_equation_id_fk", dependent: :delete

  add_foreign_key "equation_lines", "equations", name: "equation_lines_equation_id_fk", dependent: :delete
  add_foreign_key "equation_lines", "possible_answers", name: "equation_lines_possible_answer_id_fk", dependent: :delete

  add_foreign_key "equations", "procedures", name: "equations_procedure_id_fk", dependent: :delete

  add_foreign_key "inbound_text_messages", "patients", name: "inbound_text_messages_patient_id_fk", dependent: :delete

  add_foreign_key "outbound_text_messages", "patients", name: "outbound_text_messages_patient_id_fk", dependent: :delete

  add_foreign_key "patients", "users", name: "patients_user_id_fk"

  add_foreign_key "pedometer_entries", "patients", name: "pedometer_entries_patient_id_fk", dependent: :delete

  add_foreign_key "phone_polls", "patients", name: "phone_polls_patient_id_fk", dependent: :delete

  add_foreign_key "possible_answers", "questions", name: "possible_answers_question_id_fk", dependent: :delete

  add_foreign_key "procedures", "procedure_groups", name: "procedures_procedure_group_id_fk", dependent: :delete

  add_foreign_key "spirometer_entries", "patients", name: "spirometer_entries_patient_id_fk", dependent: :delete

end
