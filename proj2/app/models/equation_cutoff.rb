class EquationCutoff < ActiveRecord::Base
  belongs_to :equation

  attr_accessible :equation_id, :equation, :percentile, :value

  validates :percentile, presence: true
  validates :value, presence: true
  validates :equation_id, presence: true
end
