class AddPosFuelCapacityToPosTable < ActiveRecord::Migration
  def change
    add_column :pos, :posCapacity, :integer
  end
end
