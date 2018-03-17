class CreateTopologies < ActiveRecord::Migration[5.1]
  def change
    create_table :topologies do |t|
      t.string :name

      t.timestamps
    end
  end
end
