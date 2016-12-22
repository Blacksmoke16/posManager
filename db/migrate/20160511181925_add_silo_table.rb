class AddSiloTable < ActiveRecord::Migration
  def change
    create_table :silos, id: false do |t|
      t.integer :itemID, limit: 8, primary: true
      t.integer :posID, limit: 8
      t.integer :corpID
      t.string :siloName
      t.integer :locationID
      t.integer :gooTypeID
      t.integer :gooAmount
      t.string  :gooName
      t.decimal :gooVolume, :precision => 10, :scale => 5
      t.integer :x, limit: 8
      t.integer :y, limit: 8
      t.integer :z, limit: 8
    end
  end
end
