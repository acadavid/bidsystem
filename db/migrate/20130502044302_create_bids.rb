class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :amount, :null => false
      t.references :user
      t.references :auction

      t.timestamps
    end
    add_index :bids, :user_id
    add_index :bids, :auction_id
  end
end
