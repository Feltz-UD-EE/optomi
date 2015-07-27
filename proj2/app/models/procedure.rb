class Procedure < ActiveRecord::Base
  belongs_to :procedure_group
  has_many :equations
  has_many :assessments
  
  has_many :organization_procedures
  has_many :organizations, through: :organization_procedures

  attr_accessible :name, :sort_order, :procedure_group_id, :created_at, :updated_at
  
  validates :name, :presence => true
  validates :sort_order, :presence => true
  validates :procedure_group_id, presence: true
  
  default_scope order("#{table_name}.sort_order")
    
  def average_alos
    self.equations.find_by_equation_type(Equation::TYPES[:alos]).equation_cutoffs.find_by_percentile(50).value
  end
    
  def average_majcomp
    self.equations.find_by_equation_type(Equation::TYPES[:major_complication]).equation_cutoffs.find_by_percentile(50).value
  end
  
  def average_morbidity
    self.equations.find_by_equation_type(Equation::TYPES[:morbidity]).equation_cutoffs.find_by_percentile(50).value
  end
  
  def questions
    Question.joins(possible_answers: [equation_lines: [equation: :procedure]]).where(procedures: { id: id }).uniq
  end
  
  def displayable_average_majcomp
    if self.average_majcomp < 0.01
      "<1"
    else
      (self.average_majcomp * 100).round.to_s
    end
  end

  def displayable_average_morbidity
    if self.average_morbidity < 0.01
      "<1"
    else
      (self.average_morbidity * 100).round.to_s
    end
  end

end
