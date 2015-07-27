class MeasurementRecording < ActiveRecord::Base

  belongs_to :calendar_day

  belongs_to :patient_measurement
  belongs_to :patient_measurement_context
  belongs_to :patient_custom_measurement
  belongs_to :patient_custom_measurement_context

  def measurement
    if patient_custom_measurement_id
      patient_custom_measurement
    elsif patient_measurement_id
      patient_measurement.measurement
    else
      raise ActiveRecord::RecordInvalid.new('MeasurementRecording not setup properly')
    end
  end
end
