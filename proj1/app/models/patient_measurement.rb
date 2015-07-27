class PatientMeasurement < ActiveRecord::Base

  belongs_to :patient
  belongs_to :measurement

  has_many :patient_measurement_contexts
  has_many :measurement_recordings
  has_many :patient_custom_measurement_contexts
end
