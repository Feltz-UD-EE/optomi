class ApiClient < ActiveRecord::Base
  class InvalidClientUid < StandardError; end

  has_one :organization
  has_many :access_tokens

  default_scope { eager_load :organization }

  validates :name, :access_token, :uid, presence: true

  before_validation :generate_access_token, :generate_uid, on: :create

  private
  def generate_access_token
    self.access_token = TokenGenerator.generate(TokenGenerator::TYPES[:token])
  end

  def generate_uid
    self.uid = TokenGenerator.generate(TokenGenerator::TYPES[:uid])
  end
end
