# Copyright 2013 Ideomed, Inc. All rights reserved

class CaseManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  has_and_belongs_to_many :codes
end
