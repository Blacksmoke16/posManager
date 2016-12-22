# frozen_string_literal: true
class Silo < ActiveRecord::Base
  self.table_name = 'silos'
  self.primary_key = 'itemID'

  belongs_to :pos, foreign_key: 'posID', primary_key: 'posID'
end
