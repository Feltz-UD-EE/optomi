class PatientMeasurementContext < ActiveRecord::Base

  belongs_to :measurement_context
  belongs_to :patient_measurement

  has_many :measurement_recordings
end
