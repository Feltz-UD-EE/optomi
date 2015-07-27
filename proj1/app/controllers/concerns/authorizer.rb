module Authorizer
  extend ActiveSupport::Concern

  private
  def require_organization_stack
    if current_organization && current_case_manager
      true
    else
      handle_standard_error :auth_no_current_organization_stack
    end
  end

  module ClassMethods
    def require_organization_stack(*args)
      before_action :require_organization_stack, *args
    end
  end
end