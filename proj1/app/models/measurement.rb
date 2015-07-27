class Measurement < ActiveRecord::Base

  has_many :measurement_contexts
  has_many :patient_measurements
  has_many :condition_measurements
  has_many :conditions, through: :condition_measurements
  has_many :alerts

  default_scope { eager_load(:translations) }

  translates :name, :fractional_numerator_label, :fractional_denominator_label, :delta_label

  def type
    'Standard'
  end
  def as_json(options = nil)
    options[:methods] = [options[:methods], :type].flatten.compact
    super options
  end
end

