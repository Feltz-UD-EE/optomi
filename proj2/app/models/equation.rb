class Equation < ActiveRecord::Base
  belongs_to :procedure
  has_many :equation_lines
  has_many :equation_cutoffs
  
  attr_accessible :equation_type, :age_coeff, :intercept, :procedure_id, :created_at, :updated_at

  TYPES = { alos: 1, major_complication: 2, morbidity: 3 }

  validates :equation_type, :presence => true, inclusion: { in: TYPES.values }
  validates :age_coeff, :presence => true
  validates :intercept, :presence => true
  validates :procedure_id, presence: true

  scope :alos, -> { where(equation_type: TYPES[:alos]) }
  scope :major_complication, -> { where(equation_type: TYPES[:major_complication]) }
  scope :morbidity, -> { where(equation_type: TYPES[:morbidity]) }
  
  def calculate_raw(assessment)
    total = self.intercept + assessment.patient_age * self.age_coeff
    self.equation_lines.each do |line|
      if assessment.possible_answers.include?(line.possible_answer)
        total += line.coeff
      end
    end
    if equation_type == TYPES[:alos]
      Math::E**total
    else
      Math::E**total/(1 + Math::E**total)  
    end
  end
  
  def calculate_percentile(value)
    equation_cutoff = equation_cutoffs.where("equation_cutoffs.value >= ?", value)
                                      .order('equation_cutoffs.value ASC')
                                      .limit(1).first

    unless equation_cutoff
      equation_cutoff = equation_cutoffs.find_by_percentile(99)
    end
    equation_cutoff.percentile + 1
  end
  
end
