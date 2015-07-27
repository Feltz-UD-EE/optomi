class CalendarDay < ActiveRecord::Base

  belongs_to :patient

  has_many :measurement_recordings
  has_many :symptom_recordings
  has_many :patient_symptoms, through: :symptom_recordings
  has_many :symptoms, through: :patient_symptoms

  has_one :non_empty_calendar_day

  scope :for_date_range, ->(date_range) { where("calendar_days.date BETWEEN ? and ?",
                                                date_range.first,
                                                date_range.last) }

  serialize :conditions, Array

end
