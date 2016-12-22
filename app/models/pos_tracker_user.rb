# frozen_string_literal: true
class PosTrackerUser < ActiveRecord::Base
  self.primary_key = 'id'

  belongs_to :user, foreign_key: 'characterID'
  belongs_to :pos, foreign_key: 'posID', primary_key: 'posID'
end
