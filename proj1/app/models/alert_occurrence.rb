class AlertOccurrence < ActiveRecord::Base
  belongs_to :alert
  belongs_to :patient
  
  default_scope -> { eager_load(:alert) }

  scope :unreviewed, where("reviewed_at IS NULL")
  scope :reviewed, where("reviewed_at IS NOT NULL")
  
  def description
    alert.description
  end

  def as_json(options = nil)
    options[:methods] = [options[:methods], :description].flatten.compact
    super options
  end
end
