class MeasurementContext < ActiveRecord::Base

  belongs_to :measurement

  has_many :patient_measurement_contexts

end
