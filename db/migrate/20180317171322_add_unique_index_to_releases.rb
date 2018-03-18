class AddUniqueIndexToReleases < ActiveRecord::Migration[5.1]
  def change
    add_index :links, [:source_id, :target_id], unique: true
  end
end
