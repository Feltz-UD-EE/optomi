class V5::InvitationsController < ApplicationController
  #require_organization_stack

  def show
    params.require(:id)
    raise InvalidInvitationToken unless invitation = Invitation.find_by_token(params[:id])
    if invitation.invitation_type_id == InvitationType::TYPE_IDS[:request_for_sharing] || invitation.invitation_type_id == InvitationType::TYPE_IDS[:request_to_join]
      case_manager_name = invitation.users.first.first_name + " " + invitation.users.first.last_name[0] + "."
      organization_name = invitation.users.first.case_manager.organization.name
    else
      case_manager_name = organization_name = ""
    end
    render json: { id: invitation.id,
                   recipient: invitation.recipient,
                   state: invitation.state,
                   access_level: invitation.access_level,
                   personal_message: invitation.personal_message,
                   case_manager_name: case_manager_name,
                   organization_name: organization_name,
                   token: invitation.token,
                   invitation_type_id: invitation.invitation_type_id,
                   code_id: invitation.code_id,
                   patient_first_name: invitation.patient_first_name,
                   patient_last_name: invitation.patient_last_name,
                   patient_dob: invitation.patient_dob,
                   track_ids: invitation.track_ids,
                   patient_gender: invitation.patient_gender,
                   patient_is_user: invitation.patient_is_user,
                   user_first_name: invitation.user_first_name,
                   user_last_name: invitation.user_last_name,
                   user_email: invitation.user_email,
                   user_address: invitation.user_address,
                   user_city: invitation.user_city,
                   user_state: invitation.user_state,
                   user_zip_code: invitation.user_zip_code,
                   user_home_phone: invitation.user_home_phone,
                   user_mobile_phone: invitation.user_mobile_phone,
                   user_alt_phone: invitation.user_alt_phone }
  rescue InvalidInvitationToken => e
    handle_standard_error :invitation_token_invalid, e
  rescue ActionController::ParameterMissing => e
    handle_standard_error :invitation_token_missing, e    
  end
  
  def invalidate
    params.require(:invitation_id)
    raise InvalidInvitationId unless invitation = Invitation.find(params[:invitation_id])
    invitation.update_attributes(state: "dob_invalid")
    render json: { id: invitation.id,
                   recipient: invitation.recipient,
                   state: invitation.state,
                   access_level: invitation.access_level,
                   personal_message: invitation.personal_message,
                   token: invitation.token,
                   invitation_type_id: invitation.invitation_type_id,
                   code_id: invitation.code_id,
                   patient_first_name: invitation.patient_first_name,
                   patient_last_name: invitation.patient_last_name,
                   patient_dob: invitation.patient_dob,
                   track_ids: invitation.track_ids,
                   patient_gender: invitation.patient_gender,
                   patient_is_user: invitation.patient_is_user,
                   user_first_name: invitation.user_first_name,
                   user_last_name: invitation.user_last_name,
                   user_address: invitation.user_address,
                   user_city: invitation.user_city,
                   user_state: invitation.user_state,
                   user_zip_code: invitation.user_zip_code,
                   user_home_phone: invitation.user_home_phone,
                   user_mobile_phone: invitation.user_mobile_phone,
                   user_alt_phone: invitation.user_alt_phone }
  rescue InvalidInvitationId => e
    handle_standard_error :invitation_invalid, e
  rescue ActionController::ParameterMissing => e
    handle_standard_error :invitation_token_missing, e    
  end

  private
  class InvalidInvitationToken < StandardError; end
  class InvalidInvitationId < StandardError; end

end