class V5::Patients::AlertOccurrencesController < ApplicationController
  # require_organization_stack

  def index
    # patient = current_organization.patients.find(params[:patient_id])
    # if params[:case_manager_id]
      # raise CaseManagerInvalid unless params[:case_manager_id] == current_case_manager.id
    # end
#     
    # if params[:case_manager_id]
      # alert_ocs = patient.alert_occurrences.joins(:alert).where("alerts.user_id = ?", current_case_manager.user.id).order("created_at DESC")
    # else
      # alert_ocs = patient.alert_occurrences.order("created_at DESC")
    # end
    ##### replace these lines w/ equivalent of above when the authorization engine is in place    

    patient = Patient.find(params[:patient_id])
    alert_ocs = patient.alert_occurrences.order(created_at: :desc)
    render json: alert_ocs
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  rescue CaseManagerMismatch => e
    handle_standard_error :case_manager_mismatch
  end

  private
  class CaseManagerMismatch < StandardError; end

end
