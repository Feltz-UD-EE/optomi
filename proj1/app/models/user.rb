class User< ActiveRecord::Base
  include BCrypt

  include PasswordRecoverable

  belongs_to :condition
  has_one :subscription
  has_one :code, through: :subscription
  has_one :case_manager
  has_many :access_tokens
  has_many :patient_privileges
  has_many :patients, :through => :patient_privileges
  has_many :user_invitations
  has_many :invitations, :through => :user_invitations
  has_many :alerts

  validates_presence_of :email, :encrypted_password
  validates :email, uniqueness: true, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/,
                                                message: 'must be a valid email' }

  # returns a Bcrypt::Password object
  def password
    @password ||= Password.new(encrypted_password)
  end

  # set the encrypted_password variable
  def password=(pass)
    @password = Password.create(pass)
    self.encrypted_password = @password
  end

  def authenticate(pass)
    password == pass ? true : false
  end

  def email=(new_email)
    val = new_email.to_s
    self.display_email = val
    super(val.try(:downcase))
  end

  def generate_uid
    self.uid = TokenGenerator.generate(TokenGenerator::TYPES[:uid])
  end

  def generate_uid!
    generate_uid
    save!
  end

  def prepare_for_sso!
    self.authentication_token = TokenGenerator.generate(TokenGenerator::TYPES[:sso])
    self.authentication_token_reset_at = DateTime.now
    save!
  end

  def sso_url(app_url)
    "#{app_url}/?auth_token=#{authentication_token}"
  end
end
