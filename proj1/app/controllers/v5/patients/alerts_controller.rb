class V5::Patients::AlertsController < ApplicationController
  def index
    patient = Patient.find(params[:patient_id])
    alerts = patient.alerts.active.where(filter_alerts_params) + patient.all_patient_alerts.active.where(filter_alerts_params)
    render json: alerts
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  private
  def filter_alerts_params
    params.permit(:measurement_id, :patient_custom_measurement_id)
  end
end