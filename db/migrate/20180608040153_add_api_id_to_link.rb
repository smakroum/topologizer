class AddApiIdToLink < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :api_id, :integer
  end
end
