# frozen_string_literal: true
class Category < ActiveRecord::Base
  self.table_name = 'invcategories'
  self.primary_key = 'categoryID'

  belongs_to :group, foreign_key: 'categoryID', primary_key: 'categoryID'
end
