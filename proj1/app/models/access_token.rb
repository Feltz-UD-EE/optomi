class AccessToken < ActiveRecord::Base
  AUTH_TYPES = { secret: 1, mobile_pin: 2, password: 3, restricted: 4 }

  belongs_to :api_client
  belongs_to :user
  belongs_to :patient

  default_scope { eager_load(api_client: :organization, user: :case_manager) }

  before_create :generate_token, :generate_refresh_token, :set_expires_at

  def expired?
    DateTime.now.utc >= expires_at
  end
  def revoked?
    self.revoked_at.present? ? Time.current >= revoked_at : false
  end
  def refresh
    generate_token
    generate_refresh_token
    reset_expires_at
  end
  def revoke!
    self.revoked_at = Time.current
    save!
  end
  private
  def generate_token
    self.token = TokenGenerator.generate(TokenGenerator::TYPES[:token])
  end
  def generate_refresh_token
    self.refresh_token = TokenGenerator.generate(TokenGenerator::TYPES[:token])
  end
  def set_expires_at
    self.expires_at = DateTime.now + ENV['ACCESS_TOKEN_EXPIRES_IN'].to_i.seconds
  end
  alias_method :reset_expires_at, :set_expires_at
end
