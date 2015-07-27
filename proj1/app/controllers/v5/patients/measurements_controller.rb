class V5::Patients::MeasurementsController < ApplicationController
  require_organization_stack

  def index
    patient = current_organization.patients.find(params[:patient_id])
    measurements = patient.measurements + patient.patient_custom_measurements

    render json: measurements
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  def recordings
    begin_date = Date.iso8601(params.require(:begin_date))
    end_date = Date.iso8601(params.require(:end_date))
    date_range = (begin_date..end_date)

    patient = current_organization.patients.find(params[:patient_id])
    calendar_days = patient.calendar_days.for_date_range(date_range)
      .eager_load(measurement_recordings: [{ patient_measurement: :measurement }])

    date_array = date_range.to_a
    return_array = []
    date_array.each do |date|
      cd = calendar_days.select{ |cd| cd.date == date }.first
      recordings = []
      if cd
        recordings = cd.measurement_recordings.map do |mr|
          { name: mr.measurement.name,
            units: mr.measurement.unit,
            value: mr.value }
        end
      end
      return_array << { date: date,
                        measurement_recordings: recordings }
    end

    render json: return_array
  rescue ActionController::ParameterMissing => pm
    handle_standard_error :patient_missing_dates, pm
  rescue ActiveRecord::RecordNotFound => rnf
    handle_standard_error :patient_invalid_id, rnf
  rescue ArgumentError => ae
    handle_standard_error :patient_malformed_dates, ae
  end
end
