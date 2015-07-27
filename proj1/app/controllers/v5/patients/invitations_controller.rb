class V5::Patients::InvitationsController < ApplicationController

  #require_organization_stack

  def create_request_for_sharing
    patient = Patient.find(params[:patient_id])
    invite_params = request_for_sharing_params(patient_id: patient.id,
                                               invitation_type_id: InvitationType::TYPE_IDS[:request_for_sharing])
    requesting_users = invite_params.delete(:requesting_user_ids)
    invite = Invitation.create(invite_params)
    requesting_users.each do |user_id|
      invite.user_invitations.build(:user_id=>user_id)
    end
    invite.save

    url = invite.invitation_url_request_for_sharing(UrlHelper.app_url(patient.owner.condition.name))
    render json: { url: url }
  rescue InvalidAccessLevel => e
    handle_standard_error :invitation_invalid_access_level
  rescue InvalidUserIds => e
    handle_standard_error :invitation_invalid_user_ids
  rescue ActionController::ParameterMissing => e
    handle_standard_error :invitation_missing_access_level
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :patient_invalid_id, e
  end

  def create_request_to_join
    invite_params = request_to_join_params(invitation_type_id: InvitationType::TYPE_IDS[:request_to_join])
    requesting_users = invite_params.delete(:requesting_user_ids)
    invite = Invitation.create(invite_params)
    requesting_users.each do |user_id|
      invite.user_invitations.build(:user_id=>user_id)
    end
    invite.save

    render json: { url: invite.invitation_url_request_to_join(UrlHelper.app_url(invite.code.condition.name)) }
  rescue InvalidTrackIds => e
    handle_standard_error :invitation_invalid_track_ids
  rescue InvalidAccessLevel => e
    handle_standard_error :invitation_invalid_access_level
  rescue InvalidUserIds => e
    handle_standard_error :invitation_invalid_user_ids
  rescue CodeNotForCurrentOrganization => e
    handle_standard_error :invitation_invalid_code_id
  rescue InvalidPatientIsUser => e
    handle_standard_error :invitation_invalid_patient_is_user
  rescue InvalidPatientGender => e
    handle_standard_error :invitation_invalid_patient_gender
  rescue InvalidPatientDob => e
    handle_standard_error :invitation_invalid_patient_dob
  rescue MissingPatientDob => e
    handle_standard_error :invitation_missing_patient_dob
  rescue ActionController::ParameterMissing => e
    error = "invitation_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  end

  private
  class InvalidAccessLevel < StandardError; end
  class InvalidTrackIds < StandardError; end
  class CodeNotForCurrentOrganization < StandardError; end
  class InvalidPatientIsUser < StandardError; end
  class InvalidPatientGender < StandardError; end
  class InvalidPatientDob < StandardError; end
  class MissingPatientDob < StandardError; end
  class InvalidUserIds < StandardError; end

  def request_for_sharing_params(options = {})
    params.require(:access_level)
    params.require(:user_ids)
    res = params.permit(:access_level, :personal_message, { user_ids: [] }).merge(options)
    res[:access_level] = request_for_sharing_invitation_access_level(res[:access_level])
    res[:requesting_user_ids] = verify_user_ids(res.delete(:user_ids))
    res
  end

  def request_to_join_params(options = {})
    params.require(:access_level)
    params.require(:user_ids)
    params.require(:code_id)
    params.require(:patient_first_name)
    params.require(:patient_last_name)
    params.require(:patient_dob)
    params.require(:patient_is_user)
    params.require(:track_ids)
    # verify these tracks are tracks
    res = params.permit(:access_level, :code_id, :patient_first_name, :patient_last_name,
                        :patient_gender, :patient_is_user, :patient_dob,
                        :user_email, :user_first_name, :user_last_name, :user_address,
                        :user_city, :user_state, :user_zip_code, :user_home_phone,
                        :user_mobile_phone, :user_alt_phone, :personal_message,
                        { user_ids: [], track_ids: [] }).merge(options)
    res[:access_level] = join_invitation_access_level(res[:access_level])
    res[:requesting_user_ids] = verify_user_ids(res.delete(:user_ids))
    verify_track_ids(res[:track_ids])
    res[:track_ids] = res[:track_ids][0].split(',').map {|x| x.to_i}
    if res[:patient_dob]
      raise InvalidPatientDob unless valid_iso8601_date?(res[:patient_dob])
    else
      raise MissingPatientDob
    end
    # raise CodeNotForCurrentOrganization unless current_organization.codes.pluck(:id).include?(res[:code_id].to_i)
    raise InvalidPatientIsUser unless ['true', 'false'].include?(res[:patient_is_user])
    if res[:patient_gender]
      raise InvalidPatientGender unless ['m', 'f', 'o'].include?(res[:patient_gender])
    end
    res
  end

  def request_for_sharing_invitation_access_level(access_level_string)
    if access_level_string == 'read'
      Invitation::ACCESS_LEVELS[:read]
    elsif access_level_string == 'read_write'
      Invitation::ACCESS_LEVELS[:read_write]
    else
      raise InvalidAccessLevel
    end
  end

  def join_invitation_access_level(access_level_string)
    if access_level_string == 'read'
      Invitation::ACCESS_LEVELS[:read]
    elsif access_level_string == 'read_write'
      Invitation::ACCESS_LEVELS[:read_write]
    elsif access_level_string == 'none'
      Invitation::ACCESS_LEVELS[:none]
    else
      raise InvalidAccessLevel
    end
  end

  def verify_user_ids(user_ids)
    raise InvalidUserIds unless user_ids.is_a?(Array)
    # user_ids = current_organization.case_manager_users.where(uid: user_uids).ids
    # raise InvalidUserIds unless user_ids.length == user_uids.length
    user_ids
  end

  def verify_track_ids(track_ids)
    raise InvalidTrackIds unless track_ids.is_a?(Array)
    raise InvalidTrackIds unless Condition.where(id: track_ids).count ==  track_ids.length
  end

  def valid_iso8601_date?(date)
    Date.iso8601(date)
    true
  rescue ArgumentError => e
    false
  end
end
