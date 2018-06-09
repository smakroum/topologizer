class AddApiIdToNode < ActiveRecord::Migration[5.1]
  def change
    add_column :nodes, :api_id, :integer
  end
end
