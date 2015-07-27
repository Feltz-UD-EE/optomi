class Code < ActiveRecord::Base
  def self.inheritance_column
    nil
  end

  belongs_to :organization
  belongs_to :condition

  has_many :subscriptions
  has_many :users, :through => :subscriptions
  has_many :invitations
  has_many :code_features
  has_many :features, :through => :code_features
  has_many :code_tracks
  has_many :tracks, :through => :code_tracks, :source => :condition

  has_and_belongs_to_many :case_managers
end
