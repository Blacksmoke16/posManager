# frozen_string_literal: true
class Sov < ActiveRecord::Base
  self.table_name = 'sovList'
  self.primary_key = 'solarSystemID'
end
