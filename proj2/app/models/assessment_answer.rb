class AssessmentAnswer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :possible_answer
   
  attr_accessible :assessment_id, :possible_answer_id, :created_at, :updated_at

  validates :possible_answer_id, presence: true
  validates :assessment_id, presence: true
    
end
