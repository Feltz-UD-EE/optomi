class PatientCustomMeasurementContext < ActiveRecord::Base

  # these two belongs two are mutually exclusive
  belongs_to :patient_custom_measurement
  belongs_to :patient_measurement

  has_many :measurement_recordings
end
