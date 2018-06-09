class AddApiIdToTopology < ActiveRecord::Migration[5.1]
  def change
    add_column :topologies, :api_id, :integer
  end
end
