class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction
  attr_accessible :amount

  has_one :winning_auction, class_name: "Auction", foreign_key: "highest_bid_id"

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 10 }
end
