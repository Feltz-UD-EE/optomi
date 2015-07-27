class V5::PatientsController < ApplicationController
  require_organization_stack(:only => [ :engagement, :symptoms])

  def show
    patient = Patient.find(params[:id])
    render json: { id: patient.id,
                   first_name: patient.first_name,
                   last_name: patient.last_name,
                   owners_email: patient.owner_email,
                   last_sync: patient.last_sync }

  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  def engagement
    d1 = Date.iso8601(params.require(:begin_date))
    d2 = Date.iso8601(params.require(:end_date))
    date_range = d2 > d1 ? (d1..d2) : (d2..d1)
    # get needed data
    patient = current_organization.patients.find(params[:patient_id])
    necds_dates = patient.non_empty_calendar_days.for_date_range(date_range).pluck(:date)
    # format data
    engagements = date_range.map do |date|
      { date: date,
        engaged: necds_dates.include?(date) }
    end

    render json: engagements
  rescue ActionController::ParameterMissing => e
    handle_standard_error :patient_missing_dates, e
  rescue ArgumentError => e
    handle_standard_error :patient_malformed_dates, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  def symptoms
    d1 = Date.iso8601(params.require(:begin_date))
    d2 = Date.iso8601(params.require(:end_date))
    date_range = d2 > d1 ? (d1..d2) : (d2..d1)
    # get needed data
    patient = current_organization.patients.find(params[:patient_id])
    calendar_days = patient.calendar_days.for_date_range(date_range)

    symptoms_hash = date_range.map do |date|
      { date: date,
        symptoms: [] }
    end

    temp_symptoms_hash = calendar_days.map do |cd|
      symptom = symptoms_hash.find{ |s| s[:date] == cd.date }
      symptom[:symptoms] = cd.symptoms.map{ |t| t.name }
    end

    render json: symptoms_hash
  rescue ActionController::ParameterMissing => e
    handle_standard_error :patient_missing_dates, e
  rescue ArgumentError => e
    handle_standard_error :patient_malformed_dates, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  def features
    patient = Patient.find(params["patient_id"])
    code_features_array = patient.owner.code.features.map(&:name)
    render json: { features: code_features_array }
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end
end
