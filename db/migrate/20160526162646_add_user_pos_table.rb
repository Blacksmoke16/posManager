class AddUserPosTable < ActiveRecord::Migration
  def change
    create_table :pos_tracker_users do |t|
      t.integer  :characterID
      t.integer  :posID, limit: 8
      t.boolean  :visible
      t.text     :note
    end
  end
end
