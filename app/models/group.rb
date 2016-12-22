# frozen_string_literal: true
class Group < ActiveRecord::Base
  self.table_name = 'invgroups'
  self.primary_key = 'groupID'

  belongs_to :item, foreign_key: 'groupID', primary_key: 'groupID'
  has_one :category, foreign_key: 'categoryID', primary_key: 'categoryID'
end
