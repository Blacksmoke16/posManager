# frozen_string_literal: true
class Item < ActiveRecord::Base
  self.table_name = 'invtypes'
  self.primary_key = 'typeID'

  has_one :group, primary_key: 'groupID', foreign_key: 'groupID'
  has_one :category, through: :group, primary_key: 'groupID', foreign_key: 'groupID'
  has_one :market, primary_key: 'typeID', foreign_key: 'typeID'
  has_many :materials, primary_key: 'typeID', foreign_key: 'typeID'
  has_many :type_effects, primary_key: 'typeID', foreign_key: 'typeID'

  scope :minerals, -> { where(groupID: 18, published: true) }

  scope :iceProducts, -> { where(groupID: 423) }

  def packaged_volume
    if [31, 1022, 29].include? groupID # shuttle, pod, zehinr 3
      500
    elsif [893, 324, 830, 1283, 831, 25, 1527, 237, 834].include? groupID # frigs 9
      2500
    elsif [463, 543].include? groupID # mining barges 2
      3750
    elsif [420, 1305, 541, 963, 1534].include? groupID # dessy 5
      5000
    elsif [906, 26, 833, 358, 894, 906, 832].include? groupID # cruiser 7
      10_000
    elsif [1201, 419, 540].include? groupID # battlecruisers 3
      15_000
    elsif [380, 28, 1202].include? groupID # industrials 3
      20_000
    elsif [27, 898, 900].include? groupID # battleships 3
      50_000
    elsif [941].include? groupID # orca 1
      500_000
    elsif [883, 547, 485, 1538, 513, 902, 659].include? groupID # capitals 7
      1_300_000
    elsif [30].include? groupID # titan 1
      10_000_000
    else
      volume
    end
  end
end
