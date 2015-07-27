class Invitation < ActiveRecord::Base
  ACCESS_LEVELS = { read: 1, read_write: 2, none: 3 }
  STATES = { pending: 'pending', accepted: 'accepted', duplicate: 'duplicate', dob_invalid: 'dob_invalid' }

  belongs_to :patient
  belongs_to :invitation_type
  belongs_to :code

  # has_one :patient_privilege
  has_many :user_invitations
  has_many :users, :through => :user_invitations

  #serialize :requesting_user_ids, Array
  serialize :track_ids, Array

  before_create :generate_token

  scope :case_manager_created, -> { where("invitation_type_id = ? OR invitation_type_id = ?", InvitationType::TYPE_IDS[:request_for_sharing], InvitationType::TYPE_IDS[:request_to_join]) }
  scope :pending_or_dob, -> { where("state = 'dob_invalid' or state = 'pending'") }

  def invitation_url(app_url)
    "#{app_url}/rsvp/#{token}"
  end

  def invitation_url_request_for_sharing(app_url)
    "#{app_url}/rsvp/#{token}"
  end
  
  def invitation_url_request_to_join(app_url)
    "#{app_url}/en/invite?token=#{token}"
  end

  private
  def generate_token
    self.token = TokenGenerator.generate(TokenGenerator::TYPES[:invitation_token])
  end
end
