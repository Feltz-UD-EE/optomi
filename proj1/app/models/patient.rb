class Patient < ActiveRecord::Base

  has_many :access_tokens

  has_many :patient_privileges
  has_many :users, through: :patient_privileges
  has_many :case_managers, through: :users

  has_one :owner_patient_privilege, -> { where(type: 'PatientPrivilege::Owner') }, class_name: 'PatientPrivilege'
  has_one :owner, through: :owner_patient_privilege, source: :user

  has_many :patient_symptoms

  has_many :patient_measurements
  has_many :patient_measurement_contexts, through: :patient_measurements
  has_many :measurements, through: :patient_measurements
  has_many :measurement_contexts, through: :patient_measurement_contexts

  has_many :patient_custom_measurements
  has_many :patient_custom_measurement_contexts, through: :patient_custom_measurements

  has_many :patient_tracks
  has_many :tracks, through: :patient_tracks, source: :condition

  has_many :calendar_days
  has_many :non_empty_calendar_days

  has_many :invitations

  has_many :alerts
  has_many :all_patient_alerts, -> { where all_patients: true }, through: :users, source: :alerts
  has_many :alert_occurrences

  after_create :generate_mobile_id!

  def owner_email
    owner.email if owner
  end

  def mobile_pin
    mobile_id ? mobile_id.to_s(16) : nil
  end

  def generate_mobile_id
    self.mobile_id = id + 6000 if id && !mobile_id
  end
  def generate_mobile_id!
    generate_mobile_id
    save!
  end
end
