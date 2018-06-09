class AddApiIdToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :api_id, :integer
  end
end
