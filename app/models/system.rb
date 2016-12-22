# frozen_string_literal: true
class System < ActiveRecord::Base
  self.table_name = 'mapsolarsystems'
  self.primary_key = 'solarSystemID'

  has_many :stations, foreign_key: 'solarSystemID'

  belongs_to :region, foreign_key: 'regionID'
  belongs_to :constellation, foreign_key: 'constellationID'
end
