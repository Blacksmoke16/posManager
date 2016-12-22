# frozen_string_literal: true
class User < ActiveRecord::Base
  self.table_name = 'users'
  self.primary_key = 'characterID'

  belongs_to :corp, primary_key: 'corpID', foreign_key: 'corpID'
  has_many :pos_tracker_users, foreign_key: 'characterID'
end
