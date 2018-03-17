class AddTopologyToNode < ActiveRecord::Migration[5.1]
  def change
    add_column :nodes, :topology_id, :integer
  end
end
