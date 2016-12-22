# frozen_string_literal: true
class Pos < ActiveRecord::Base
  self.table_name = 'pos'
  self.primary_key = 'itemID'

  has_many :silos, foreign_key: 'posID'
  has_many :pos_tracker_users, foreign_key: 'posID'

  scope :Anchored, -> { where(state: 'Anchored') }
  scope :Onlining, -> { where(state: 'Onlining') }
  scope :Online, -> { where(state: 'Online') }
  scope :Unnchored, -> { where(state: 'Unnchored') }
  scope :Reinforced, -> { where(state: 'Reinforced') }
end
