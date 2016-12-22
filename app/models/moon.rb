# frozen_string_literal: true
class Moon < ActiveRecord::Base
  self.table_name = 'mapdenormalize'
  self.primary_key = 'itemID'
end
