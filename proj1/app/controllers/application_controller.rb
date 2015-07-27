class ApplicationController < ActionController::API
  include Authenticator
  include Authorizer
  include ApiLogger

  rescue_from Exception, with: :rescue_exception

  before_action :log_access

  private
  def handle_error(internal_error, http_status, exception, *errors)
    log_error(internal_error, http_status, exception)
    render status: http_status, json: { errors: errors }
  end
  def handle_standard_error(standard_error_type, exception=nil)
    std_error = ApiErrorLog::STANDARD_ERRORS[standard_error_type]
    handle_error(standard_error_type, std_error[:code], exception, std_error[:text])
  end
  def handle_invalid_record_error(invalid_object, exception=nil)
    error_type = :invalid_object
    error = ApiErrorLog::STANDARD_ERRORS[error_type]
    error_messages = invalid_object.errors.full_messages
    handle_error(error_type, error[:code], exception, error_messages)
  end

  def current_user
    @current_user ||= current_access_token.try(:user)
  end
  def current_case_manager
    @current_case_manager ||= current_user.try(:case_manager)
  end
  def current_api_client
    @current_api_client ||= current_access_token.try(:api_client)
  end
  def current_organization
    @current_organization ||= current_case_manager.try(:organization)
  end
  def rescue_exception(exception)
    handle_standard_error(:general_failure, exception)
  end

end
