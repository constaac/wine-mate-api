class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.string :winery
      t.string :size
      t.string :location
      t.integer :vintage
      t.string :grape
      t.integer :quantity

      t.timestamps
    end
  end
end
