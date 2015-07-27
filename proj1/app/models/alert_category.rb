class AlertCategory < ActiveRecord::Base
  has_many   :alerts

  TYPE_IDS = { measurement:   1,
               reminder:      2,
               questionnaire: 3 }

end
