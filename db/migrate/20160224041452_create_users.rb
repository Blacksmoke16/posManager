class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :characterID
			t.string  :characterName
      t.integer :corpID
			t.string  :corpName
      t.integer :allianceID
			t.string  :allianceName
    end
  end
end
