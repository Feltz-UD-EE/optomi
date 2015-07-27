class CodeTrack < ActiveRecord::Base
	belongs_to :code
	belongs_to :condition
		  
  default_scope { order(:sort_order) }

end