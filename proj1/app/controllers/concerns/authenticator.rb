module Authenticator
  extend ActiveSupport::Concern

  attr_reader :current_access_token

  included do
    before_action :authenticate
  end

  private
  def authenticate
    if token = request.headers['HTTP_TOKEN']
      if at = AccessToken.find_by(token: token)
        if at.expired?
          handle_standard_error(:expired_access_token)
        elsif at.revoked?
          handle_standard_error(:revoked_access_token)
        else
          # set the current access token
          @current_access_token = at
        end
      else
        handle_standard_error(:invalid_access_token)
      end
    else
      handle_standard_error(:missing_access_token)
    end
  end

  module ClassMethods
    def skip_authentication(*args)
      skip_before_action :authenticate, *args
    end
  end
end