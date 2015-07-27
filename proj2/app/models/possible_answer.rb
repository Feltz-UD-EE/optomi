class PossibleAnswer < ActiveRecord::Base
  belongs_to :question
  has_many :assessment_answers
  has_many :equation_lines
  
  attr_accessible :value, :question_id, :sort_order, :is_default, :created_at, :updated_at
  
  validates :value, :presence => true
  validates :sort_order, :presence => true
  validates :question_id, presence: true
  validate :only_one_default_answer_per_question
  
  default_scope order("#{table_name}.sort_order")
  
  def only_one_default_answer_per_question
    if self.is_default && self.question.possible_answers.where(:is_default => true).any?
      errors.add(:possible_answer, "already another default answer for that question")
    end
  end
end
