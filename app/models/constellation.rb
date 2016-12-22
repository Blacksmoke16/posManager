# frozen_string_literal: true
class Constellation < ActiveRecord::Base
  self.table_name = 'mapconstellations'
  self.primary_key = 'constellationID'

  belongs_to :region, foreign_key: 'constellationID'
  has_many :solarSystems, foreign_key: 'constellationID'
end
