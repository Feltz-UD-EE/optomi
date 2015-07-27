class V5::CaseManagers::AlertsController < ApplicationController
#  require_organization_stack

  def index
    raise CaseManagerInvalid unless cm = CaseManager.find_by_id(params[:case_manager_id])
    alerts = cm.user.alerts.order("created_at DESC")
    alerts_struct = alerts.map do |alert|
      { id: alert.id,
        user_id: alert.user_id,
        patient_id: alert.patient_id,
        description: alert.description,
        all_patients: alert.all_patients,
        alert_category_id: alert.alert_category_id,
        message: alert.message,
        message_type: alert.message_type,
        measurement_id: alert.measurement_id,
        patient_custom_measurement_id: alert.patient_custom_measurement_id,
        fractional_measurement_type: alert.fractional_measurement_type,
        polarity: alert.polarity,
        lower_threshold: alert.lower_threshold,
        upper_threshold: alert.upper_threshold,
        deleted_at: alert.deleted_at }
    end
    render json: { alerts_size: alerts.length,
                   alerts: alerts_struct }
  rescue CaseManagerInvalid => e
    handle_standard_error :case_manager_invalid
  end

  private
  class CaseManagerInvalid < StandardError; end
end