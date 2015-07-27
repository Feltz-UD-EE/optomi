module TokenGenerator
  TYPES = { uid: 32, token: 64, sso: 16, password: 10, reset_token: 16,
            invitation_token: 32 }

  def self.generate(n)
    SecureRandom.urlsafe_base64(n)
  end
end