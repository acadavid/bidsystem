class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :item_name, :null => false
      t.integer :current_price, :null => false
      t.boolean :active, :null => false, :default => true
      t.references :user

      t.timestamps
    end
    add_index :auctions, :user_id
  end
end
