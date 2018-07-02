class AddTopologyToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :topology, foreign_key: true
  end
end
