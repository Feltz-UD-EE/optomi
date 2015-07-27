class EquationLine < ActiveRecord::Base
  belongs_to :equation
  belongs_to :possible_answer
  
  attr_accessible :name, :coeff, :equation_id, :possible_answer_id, :created_at, :updated_at

  validates :name, :presence => true
  validates :coeff, :presence => true
  validates :equation_id, presence: true
  validates :possible_answer_id, presence: true
  
end
