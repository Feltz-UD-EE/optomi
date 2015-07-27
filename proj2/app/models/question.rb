class Question < ActiveRecord::Base
  has_many :possible_answers
  
  attr_accessible :name, :sort_order, :short_name, :created_at, :updated_at
  
  validates :name, :presence => true
  validates :sort_order, :presence => true
  
  default_scope order("#{table_name}.sort_order")

  def default_answer
    (a = self.possible_answers.find_by_is_default(true)) ? a.id : nil
  end
end
