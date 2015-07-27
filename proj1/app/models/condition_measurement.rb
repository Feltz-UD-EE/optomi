class ConditionMeasurement < ActiveRecord::Base
	belongs_to :condition
	belongs_to :measurement
end