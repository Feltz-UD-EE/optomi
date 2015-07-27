class Organization < ActiveRecord::Base
  def self.inheritance_column
    nil
  end

  belongs_to :api_client

  has_many :codes
  has_many :subscriptions, through: :codes
  has_many :users, through: :subscriptions
  has_many :patient_privileges, through: :users
  has_many :patients, -> { where("patient_privileges.type = 'PatientPrivilege::Owner'") }, through: :patient_privileges

  has_many :case_managers
  has_many :case_manager_users, through: :case_managers, source: :user

  validates :name, presence: true

end
