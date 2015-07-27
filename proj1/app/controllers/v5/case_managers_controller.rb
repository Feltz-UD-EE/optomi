class V5::CaseManagersController < ApplicationController
  # require_organization_stack

  def create
    # TODO, move to authorization
    code = Code.find_by(id: params.require(:code_id))
    raise CaseManagerInvalidCode unless code
    organization = Organization.find_by(id: params.require(:organization_id))
    raise CaseManagerInvalidOrganization unless organization
    # VERIFY
    raise OrganizationMismatch unless organization.codes.include?(code)

    user = User.new(user_params)
    user.generate_uid
    user.password = TokenGenerator.generate(TokenGenerator::TYPES[:password]) # temporary so validations work
    user.reset_password_token = TokenGenerator.generate(TokenGenerator::TYPES[:reset_token]) # used to generate unique URL
    user.reset_password_sent_at = Time.zone.now
    user.condition = code.condition
    user.build_subscription(code: code)
    user.build_case_manager(case_manager_params(organization: organization))
    user.save!
    
    render json: { id: user.id,
                   uid: user.uid,
                   email: user.email,
                   case_manager: true,
                   is_admin: user.case_manager.is_admin,
                   reset_password_url: generate_reset_url(user) }
  # rescue CaseManagerNotAdmin => e
  #   handle_standard_error :case_manager_not_admin
  rescue ActionController::ParameterMissing => e
    error = "case_manager_create_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue ActiveRecord::RecordInvalid => e
    handle_invalid_record_error e.record, e
  rescue CaseManagerInvalidOrganization => e
    handle_standard_error :case_manager_create_invalid_organization_id, e
  rescue CaseManagerInvalidCode => e
    handle_standard_error :case_manager_create_invalid_code_id, e
  rescue OrganizationMismatch => e
    handle_standard_error :case_manager_create_organization_mismatch, e
  # rescue CurrentOrganizationMismatch => e
  #   handle_standard_error :case_manager_create_current_organization_mismatch, e
  end

  def designate
    # TODO - this should be part of authorization

    user = User.eager_load(:case_manager).find(params.require(:user_id))
    raise CaseManagerAlreadyExists if user.case_manager
    organization = Organization.find_by(id: params.require(:organization_id))
    raise CaseManagerInvalidOrganization unless organization
    raise OrganizationMismatch unless user.code.organization_id == organization.id
    user.generate_uid unless user.uid
    user.build_case_manager(case_manager_params(organization: organization))
    user.save!
    render json: { id: user.id,
                   uid: user.uid,
                   email: user.email,
                   case_manager: true,
                   is_admin: user.case_manager.is_admin }
  rescue ActionController::ParameterMissing => e
    error = "case_manager_designate_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :case_manager_invalid_user, e
  rescue CaseManagerAlreadyExists => e
    handle_standard_error :case_manager_already_exists
  rescue OrganizationMismatch => e
    handle_standard_error :case_manager_designate_organization_mismatch, e
  rescue CaseManagerInvalidOrganization => e
    handle_standard_error :case_manager_designate_invalid_organization_id, e
  end

  private
  class CaseManagerInvalidCode < StandardError; end
  class CaseManagerInvalidOrganization < StandardError; end
  class InvalidUserPassword < StandardError; end
  class CaseManagerAlreadyExists < StandardError; end
  class CaseManagerNotAdmin < StandardError; end
  class OrganizationMismatch < StandardError; end
  class CurrentOrganizationMismatch < StandardError; end

  def user_params
    params.require(:email)
    params.require(:first_name)
    params.require(:last_name)
    params.require(:address)
    params.require(:city)
    params.require(:state)
    params.require(:zip_code)
    params.require(:home_phone)

    params.permit(:email, :first_name, :last_name, :address, :city, :state, :zip_code, :home_phone, :alt_phone)
  end

  def case_manager_params(options={})
    params.permit(:is_admin).merge(options)
  end

  def generate_reset_url(user)
    "#{UrlHelper.app_url(user.condition.name)}/users/password/edit?reset_password_token=#{user.reset_password_token}"
  end
end
