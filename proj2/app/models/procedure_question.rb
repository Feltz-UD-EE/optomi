class ProcedureQuestion < ActiveRecord::Base
  belongs_to :procedure
  belongs_to :question
  
  attr_accessible :procedure_id, :question_id, :created_at, :updated_at
  
    
end
