class AddCurrentToTopology < ActiveRecord::Migration[5.1]
  def change
    add_column :topologies, :is_current, :boolean, :default => false, :null => false
  end
end
