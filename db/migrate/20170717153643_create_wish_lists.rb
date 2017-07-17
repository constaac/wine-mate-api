class CreateWishLists < ActiveRecord::Migration[5.0]
  def change
    create_table :wish_lists do |t|
      t.string :name, null: false, default: ''
      t.string :winery, null: false, default: ''
      t.string :size, null: false, default: 'Standard'
      t.string :location
      t.integer :vintage
      t.string :grape
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
