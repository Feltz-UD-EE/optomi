class CodeFeature < ActiveRecord::Base

  belongs_to :code
  belongs_to :feature
  
  default_scope { order(:sort_order) }
end