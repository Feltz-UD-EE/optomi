class V5::AlertOccurrencesController < ApplicationController
  def show
    alert_oc = AlertOccurrence.find(params[:id])
    render json: alert_oc
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_occurrence_not_found, e
  end

  def create
    raise Errors::RecordAlreadyDestroyed if Alert.find(params.require(:alert_id)).deleted_at
    alert_oc = AlertOccurrence.create!(alert_occurrence_params)
    render json: alert_oc
  rescue ActionController::ParameterMissing => e
    error = "alert_occurrence_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_occurrence_invalid_alert_id, e
  rescue Errors::RecordAlreadyDestroyed => e
    handle_standard_error :alert_occurrence_invalid_deleted_alert, e
  end

  def update
    alert_occurrence = AlertOccurrence.find(params[:id])
    alert_occurrence.update!(update_alert_occurrence_params)
    render json: alert_occurrence
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_occurrence_not_found, e
  end

  private
  def alert_occurrence_params
    params.require(:patient_id)
    params.permit(:alert_id, :patient_id, :recorded_value, :reviewed_at)
  end

  def update_alert_occurrence_params
    params.permit(:recorded_value, :reviewed_at)
  end
end
