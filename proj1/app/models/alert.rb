class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :patient
  belongs_to :measurement
  belongs_to :patient_custom_measurement
  belongs_to :alert_category
  has_many   :alert_occurrences

  validates_presence_of :user_id
  # notify_type = ["email"|"sms"]
  # polarity = ["greater_than", "less_than", "delta_positive", "delta_negative"]

  validate :patient_or_all_patients, on: :create
  validate :allowed_alert_categories, on: :create
  validate :allowed_polarity_choices, on: :create
  validate :category_measurement_has_measurement, on: :create
  validate :category_measurement_has_only_one_measurement, on: :create
  validate :category_measurement_has_polarity, on: :create
  validate :category_measurement_has_lower_threshold, on: :create
  validate :category_reminder_has_lower_threshold, on: :create

  scope :active, -> { where(deleted_at: nil) }
  scope :measurement, -> { where(alert_category_id: AlertCategory::TYPE_IDS[:measurement]) }
  scope :reminder, -> { where(alert_category_id: AlertCategory::TYPE_IDS[:reminder]) }
  scope :questionnaire, -> { where(alert_category_id: AlertCategory::TYPE_IDS[:questionnaire]) }
  scope :all_patients, -> { where(all_patients: true) }

  alias_method :original_update!, :update!
  def update!(attributes)
    dup_alert = dup
    self.class.transaction do
      dup_alert.original_update!(attributes)
      self.destroy!
    end
    dup_alert
  end

  def destroy!
    unless deleted_at

      self if original_update!(deleted_at: Time.current)
    else
      raise Errors::RecordAlreadyDestroyed
    end
  end

  def description
    case self.alert_category_id
    when 1  # measurment
      meas = (self.measurement_id.nil? ? self.patient_custom_measurement : self.measurement)
      if meas.nil?
        "(invalid measurement setting)"
      else
        if fractional_measurement_type == 'numerator'
          frac = measurement.fractional_numerator_label ? " (#{measurement.fractional_numerator_label})" : ' (Numerator)'
        elsif fractional_measurement_type == 'denominator'
          frac = measurement.fractional_denominator_label ? " (#{measurement.fractional_denominator_label})" : ' (Denominator)'
        end
        case self.polarity
        when "greater_than"
          "#{meas.name}#{frac} is greater than #{self.lower_threshold} #{meas.unit}"
        when "less_than"
          "#{meas.name}#{frac} is less than #{self.lower_threshold} #{meas.unit}"
        when "delta_positive"
          "#{meas.name}#{frac} has increased by #{self.lower_threshold} #{meas.unit} in one day"
        when "delta_negative"
          "#{meas.name}#{frac} has decreased by #{self.lower_threshold} #{meas.unit} in one day"
        else
          "#{meas.name}#{frac} (invalid polarity setting) #{self.lower_threshold} #{meas.unit}"
        end
      end
    when 2  # reminder
      "Has missed more than #{self.lower_threshold} doses/reminders"
    when 3  # questionnaire
      "Has a questionnaire alert"
    else
      "(invalid alert_category)"
    end
  end

  def as_json(options = nil)
    options[:methods] = [options[:methods], :description].flatten.compact
    super options
  end

  private
  def patient_or_all_patients
    if !all_patients && patient_id.nil?
      errors.add(:base, "Please include a valid patient id.")
    end
  end
  def allowed_alert_categories
    unless alert_category_id && alert_category_id >= 1 && alert_category_id <= 3     
      errors.add(:base, "Please provide a valid choice for alert_category_id.")
    end
  end
  def allowed_polarity_choices
    unless polarity.nil? || polarity == "greater_than" || polarity == "less_than" || polarity == "delta_positive" || polarity == "delta_negative"      
      errors.add(:base, "Please provide a valid choice for polarity.")
    end
  end
  def category_measurement_has_measurement
    if alert_category_id == 1 && measurement_id.nil? && patient_custom_measurement_id.nil?
      errors.add(:base, "Please provide a measurement_id or patient_custom_measurement_id for this category of alert.")
    end
  end
  def category_measurement_has_only_one_measurement
    if alert_category_id == 1 && measurement_id && patient_custom_measurement_id
      errors.add(:base, "Please provide either a measurement_id or a patient_custom_measurement_id, not both.")
    end
  end
  def category_measurement_has_polarity
    if alert_category_id == 1 && polarity.nil?
      errors.add(:base, "Please provide a polarity for this category of alert")
    end
  end
  def category_measurement_has_lower_threshold
    if alert_category_id == 1 && lower_threshold.blank?
      errors.add(:base, "Please provide a threshold")
    end
  end  
  def category_reminder_has_lower_threshold
    if alert_category_id == 2 && lower_threshold.blank?
      errors.add(:base, "Please provide a threshold")
    end
  end
  def lower_threshold_is_numeric
    if alert_category_id == 1 || alert_category_id == 2
      if !(/^[+-]?(?:\d+\.?\d*|\d*\.\d+)$/ =~ lower_threshold) && !lower_threshold.nil?
        errors.add(:base, "Lower threshold must be numeric")
      end
    end
  end
  def upper_threshold_is_numeric
    if alert_category_id == 1 || alert_category_id == 2
      if !(/^[+-]?(?:\d+\.?\d*|\d*\.\d+)$/ =~ upper_threshold) && !upper_threshold.nil?
        errors.add(:base, "Upper threshold must be numeric")
      end
    end
  end


end
