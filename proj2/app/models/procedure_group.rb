class ProcedureGroup < ActiveRecord::Base
  has_many :procedures
  
  attr_accessible :name, :sort_order, :created_at, :updated_at
    
  validates :name, :presence => true
  validates :sort_order, :presence => true
  
  default_scope order("#{table_name}.sort_order")
  
  def procedures_for_org(organization)
    self.procedures.joins(:organization_procedures).where(organization_procedures: { organization_id: organization.id})
  end
end
