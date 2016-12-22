class AddStrontConsumptionColumn < ActiveRecord::Migration
  def change
    add_column :pos, :strontConsumption, :integer, :after => :strontAmount
  end
end
