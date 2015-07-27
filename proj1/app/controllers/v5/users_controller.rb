class V5::UsersController < ApplicationController
  require_organization_stack
  def sso
    current_user.prepare_for_sso!
    url = current_user.sso_url(UrlHelper.app_url(current_user.condition.name))
    render json: { url: url }
  end
end
