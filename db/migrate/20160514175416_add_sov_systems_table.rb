class AddSovSystemsTable < ActiveRecord::Migration
  def change
    create_table :sovList, id: false do |t|
      t.integer :solarSystemID, limit: 8, primary: true
      t.string  :solarSystemName
      t.integer :corpID
      t.integer :allianceID
      t.integer :factionID
    end
  end
end
