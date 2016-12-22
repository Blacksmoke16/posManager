# frozen_string_literal: true
class Region < ActiveRecord::Base
  self.table_name = 'mapregions'
  self.primary_key = 'regionID'

  has_many :systems, foreign_key: 'regionID'
  has_many :constellations, foreign_key: 'regionID'
end
