class AddLinkBelongsToTopology < ActiveRecord::Migration[5.1]
  def change
    add_reference :links, :topology, foreign_key: true
  end
end
