class PatientSymptom < ActiveRecord::Base
  belongs_to :patient
  belongs_to :symptom
end
