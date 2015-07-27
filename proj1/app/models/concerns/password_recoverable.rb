module PasswordRecoverable

  # set the reset_password_token
  def generate_reset_password_token
    self.reset_password_token = TokenGenerator.generate(TokenGenerator::TYPES[:reset_token])
    self.reset_password_sent_at = Time.current
  end

  def generate_reset_password_token!
    generate_reset_password_token
    save!
  end

  # return a url that the user can reset their password at
  def reset_password_url(url)
    "#{url}/#{self.class.name.pluralize.downcase}/password/edit?reset_password_token=#{self.reset_password_token}"
  end
end