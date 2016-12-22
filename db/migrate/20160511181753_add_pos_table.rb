class AddPosTable < ActiveRecord::Migration
  def change
    create_table :pos, id: false do |t|
      t.integer :itemID, limit: 8, primary: true
      t.string  :itemName
      t.integer :typeID
      t.string  :typeName
      t.integer :locationID
      t.string  :locationName
      t.integer :fuelAmount
      t.integer :fuelType
      t.string  :fuelTypeName
      t.integer :fuelConsumption
      t.integer :strontAmount
      t.integer :siloCapacity
      t.integer :regionID
      t.string  :regionName
      t.integer :constellationID
      t.string  :constellationName
      t.integer :moonID
      t.string :state
      t.datetime :stateTimestamp
      t.datetime :onlineTimestamp
      t.integer :corpID
      t.integer :allianceID
      t.boolean :sovBonus
      t.boolean :allowAllianceUsage
      t.boolean :allowCorporationUsage
      t.boolean :siphon
      t.integer :x, limit: 8
      t.integer :y, limit: 8
      t.integer :z, limit: 8
    end
  end
end
