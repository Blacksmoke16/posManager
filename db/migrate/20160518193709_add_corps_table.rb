class AddCorpsTable < ActiveRecord::Migration
  def change
    create_table :corps do |t|
      t.integer :corpID
      t.string  :corpName
      t.integer :allianceID
      t.string  :allianceName
      t.string :keyID
      t.string :vCode
    end
  end
end
