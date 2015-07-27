class Condition < ActiveRecord::Base
  has_many :documents
  has_many :users
  has_many :condition_measurements
  has_many :measurements, :through => :condition_measurements
  has_many :patient_tracks
  has_many :patients, through: :patient_tracks
end
