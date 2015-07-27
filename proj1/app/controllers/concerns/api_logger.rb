module ApiLogger
  extend ActiveSupport::Concern

  private
  def log_access
    ApiAccessLog.create(user: current_user,
                        api_client: current_api_client,
                        request: request.env['REQUEST_URI'],
                        params: params)
  end

  def log_error(internal_code, http_status, exception)
    ApiErrorLog.create(user: current_user,
                       api_client: current_api_client,
                       internal_code: internal_code.to_s,
                       http_code: http_status,
                       request: request.env['REQUEST_URI'],
                       params: params,
                       exception_message: exception.try(:message),
                       exception_backtrace: exception.try(:backtrace))
  end

end