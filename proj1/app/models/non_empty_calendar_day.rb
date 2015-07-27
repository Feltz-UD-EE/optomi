class NonEmptyCalendarDay < ActiveRecord::Base

  belongs_to :patient
  belongs_to :calendar_day

  has_many :measurement_recordings, through: :calendar_day

  scope :for_date_range, ->(date_range) { where("non_empty_calendar_days.date BETWEEN ? and ?",
                                                date_range.first,
                                                date_range.last) }

  serialize :conditions, Array

end
