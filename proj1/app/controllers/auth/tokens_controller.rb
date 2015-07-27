class Auth::TokensController < ApplicationController
  skip_authentication :all
  def create
    auth_type = params.require(:auth_type)

    if auth_type == 'secret'
      api_client = verify_api_client(:server)
      at = create_access_token_by_secret(api_client,
                                         params.require(:client_secret),
                                         params.require(:user_uid))
    elsif auth_type == 'mobile_pin'
      api_client = verify_api_client(:mobile)
      at = create_access_token_by_mobile_pin(api_client,
                                             params.require(:user_email),
                                             params.require(:patient_mobile_pin))
    elsif auth_type == 'restricted'
      api_client = verify_api_client(:server, :mobile)
      at = create_restricted_access_token(api_client)
    else
      raise InvalidAuthType.new('Invalid auth_type')
    end
    render json: { token: at.token,
                   refresh_token: at.refresh_token,
                   expires_at: at.expires_at }
  rescue ActionController::ParameterMissing => e
    # grab which param was missing and combine it with auth_missing to create the STD_ERROR
    error = "auth_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue InvalidClientUid => e
    handle_standard_error :auth_invalid_client_uid, e
  rescue InvalidClientSecret => e
    handle_standard_error :auth_invalid_client_secret, e
  rescue InvalidClientType => e
    handle_standard_error :auth_invalid_client_type, e
  rescue InvalidUserUid => e
    handle_standard_error :auth_invalid_user_uid, e
  rescue InvalidUserEmail => e
    handle_standard_error :auth_invalid_user_email, e
  rescue InvalidPatientMobilePin => e
    handle_standard_error :auth_invalid_patient_mobile_pin, e
  rescue InvalidUserForClient => e
    handle_standard_error :auth_invalid_user_for_client, e
  rescue InvalidUserForPatient => e
    handle_standard_error :auth_invalid_user_for_patient, e
  rescue InvalidAuthType => e
    handle_standard_error :auth_invalid_auth_type, e
  end

  def refresh
    access_token = AccessToken.find_by(token: params.require(:token))
    raise InvalidAccessToken.new('Access token for specified token not found') unless access_token
    if access_token.refresh_token == params.require(:refresh_token)
      if access_token.expired?
        access_token.refresh
        access_token.save!
      else
        raise AccessTokenNotExpired.new('Specified access token is not expired')
      end
    else
      raise InvalidRefreshToken.new('Specified refresh token does not match found access token')
    end

    render json: { token: access_token.token,
                   refresh_token: access_token.refresh_token,
                   expires_at: access_token.expires_at }
  rescue ActionController::ParameterMissing => e
    error = "auth_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue AccessTokenNotExpired => e
    handle_standard_error :auth_access_token_not_expired, e
  rescue InvalidAccessToken => e
    handle_standard_error :auth_invalid_access_token, e
  rescue InvalidRefreshToken => e
    handle_standard_error :auth_invalid_refresh_token, e
  end

  def revoke
    access_token = AccessToken.find_by(token: params.require(:token))
    raise InvalidAccessToken.new('Access token for specified token not found') unless access_token
    if access_token.revoked?
      raise AccessTokenAlreadyRevoked.new('Specified access token is already revoked')
    else
      access_token.revoke!
      render json: { revoked_at: access_token.revoked_at }
    end
  rescue ActionController::ParameterMissing => e
    error = "auth_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  rescue InvalidAccessToken => e
    handle_standard_error :auth_invalid_access_token, e
  rescue AccessTokenAlreadyRevoked => e
    handle_standard_error :auth_access_token_already_revoked, e
  end

  private
  class InvalidAuthType < StandardError; end
  class InvalidClientUid < StandardError; end
  class InvalidClientSecret < StandardError; end
  class InvalidClientType < StandardError; end
  class InvalidUserUid < StandardError; end
  class InvalidUserEmail < StandardError; end
  class InvalidPatientMobilePin < StandardError; end
  class InvalidUserForClient < StandardError; end
  class InvalidUserForPatient < StandardError; end
  class InvalidAuthType < StandardError; end
  class InvalidAccessToken < StandardError; end
  class InvalidRefreshToken < StandardError; end
  class AccessTokenNotExpired < StandardError; end
  class AccessTokenAlreadyRevoked < StandardError; end

  def create_access_token_by_secret(api_client, client_secret, user_uid)
    user = User.find_by(uid: user_uid)
    raise InvalidUserUid.new('User with specified uid not found') unless user
    if organization = api_client.organization
      # the client is an organization
      # we need to verify that the user is a case_manager that belongs to this organization
      raise InvalidUserForClient.new('Invalid user for the client') unless organization == user.case_manager.try(:organization)
    end
    AccessToken.create(user: user,
                       api_client: api_client,
                       auth_type: AccessToken::AUTH_TYPES[:secret])
  end

  def create_access_token_by_mobile_pin(api_client, email, mobile_pin)
    user = User.find_by(email: email)
    raise InvalidUserEmail.new('User with specified email not found.') unless user
    patient = Patient.find_by(mobile_id: mobile_pin.to_i(16))
    raise InvalidPatientMobilePin.new('Patient with specified mobile pin not found.') unless patient

    unless patient.owner.id == user.id
      raise InvalidUserForPatient.new('Specified user is not owner of patient.')
    end

    AccessToken.create(user: user,
                       patient: patient,
                       api_client: api_client,
                       auth_type: AccessToken::AUTH_TYPES[:mobile_pin])
  end

  def create_restricted_access_token(api_client)
    AccessToken.create(api_client: api_client,
                       auth_type: AccessToken::AUTH_TYPES[:restricted])
  end

  def verify_api_client(*allowed_client_types)
    api_client = ApiClient.find_by uid: params.require(:client_uid)
    raise InvalidClientUid.new('ApiClient with specified uid not found.') unless api_client
    # check that the client_type is allowed
    raise InvalidClientType.new('ApiClient is not of allowed type.') unless allowed_client_types.map(&:to_s).include?(api_client.client_type)
    # check the client_secret value if appropriate
    if api_client.client_type == 'server' && api_client.access_token != params.require(:client_secret)
      raise InvalidClientSecret.new('Specified client_secret does not match found client.')
    end
    api_client
  end
end
