# Copyright 2013 Ideomed, Inc. All rights reserved

class ApiAccessLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :api_client
  
  serialize :params
end
