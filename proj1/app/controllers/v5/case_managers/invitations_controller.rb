class V5::CaseManagers::InvitationsController < ApplicationController

  #require_organization_stack

  def index  
    # authorization stuff goes here
    #
    #
    this_case_manager = CaseManager.find(params[:case_manager_id])
    raise InvalidCaseManagerId unless   this_case_manager
    # raise UnauthorizedCaseManager unless current_case_manager.id == params[:case_manager_id].to_i
    # this_case_manager = current_case_manager
    #
    #
    #
    invitations = this_case_manager.user.invitations.case_manager_created.pending_or_dob.order(:created_at)
    invitations_struct = invitations.map do |invite|
      { id: invite.id,
        patient_first_name: invite.patient_first_name,
        patient_last_name: invite.patient_last_name,
        patient_DOB: invite.patient_dob.try(:strftime, "%Y-%m-%dT%T.%LZ"),
        patient_phone: invite.user_mobile_phone,
        patient_email: invite.user_email,
        invite_type: invite.invitation_type.description,
        invite_state: invite.state,
        invite_sent_on: invite.created_at.try(:strftime, "%Y-%m-%dT%T.%LZ")}
    end    
    render json: { invitations_size: invitations.length,
                   invitations: invitations_struct }
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :case_manager_invalid_id, e
  end

  private
  class UnauthorizedCaseManager < StandardError; end
  class InvalidCaseManagerId < StandardError; end
end