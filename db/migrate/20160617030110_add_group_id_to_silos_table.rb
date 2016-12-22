class AddGroupIdToSilosTable < ActiveRecord::Migration
  def change
    add_column :silos, :gooGroupID, :integer, :after => :gooTypeID
  end
end
