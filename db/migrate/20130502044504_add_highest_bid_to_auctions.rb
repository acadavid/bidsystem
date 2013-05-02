class AddHighestBidToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :highest_bid_id, :integer
    add_index :auctions, :highest_bid_id
  end
end
