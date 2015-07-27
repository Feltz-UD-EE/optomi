class SymptomRecording < ActiveRecord::Base
  belongs_to :calendar_day
  belongs_to :patient_symptom
end
