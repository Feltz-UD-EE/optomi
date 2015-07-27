class InvitationType < ActiveRecord::Base
  TYPE_IDS = { sharing: 1,
               request_for_sharing: 2,
               request_to_join: 3 }

  has_many :invitations
end