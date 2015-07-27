class PatientCustomMeasurement < ActiveRecord::Base

  belongs_to :patient

  has_many :patient_custom_measurement_contexts
  has_many :measurement_recordings
  has_many :alerts

  def type
    'Custom'
  end
  def as_json(options = nil)
    options[:methods] = [options[:methods], :type].flatten.compact
    super options
  end
end
