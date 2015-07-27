class PatientPrivilege < ActiveRecord::Base
  def self.inheritance_column
    nil
  end
  belongs_to :user
  belongs_to :patient

  belongs_to :invitation
  
  default_scope { where("#{self.table_name}.deleted_at IS NULL") }
  
end