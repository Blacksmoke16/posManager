# frozen_string_literal: true
class Corp < ActiveRecord::Base
  self.table_name = 'corps'
  self.primary_key = 'corpID'
end
