class Symptom < ActiveRecord::Base
  has_many :patient_symptoms
end
