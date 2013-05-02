require 'bidsystem_exceptions'

class User < ActiveRecord::Base
  attr_accessible :budget, :email, :name

  validates :name, presence: true
  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :auctions, dependent: :destroy

  has_many :bids, dependent: :destroy
  has_many :bidded_auctions, through: :bids, source: :auction

  def winning_auctions
    bidded_auctions.where("\"auctions\".\"highest_bid_id\" = \"bids\".\"id\" AND \"auctions\".\"active\" = 't'")
  end

  def won_auctions
    bidded_auctions.where("\"auctions\".\"highest_bid_id\" = \"bids\".\"id\" AND \"auctions\".\"active\" = 'f'")
  end

  def blocked_budget
    winning_auctions.sum(:amount).to_i
  end

  def budget
    return nil if self[:budget].nil?
    self[:budget] - blocked_budget
  end

  def bid(auction, amount)
    raise BidsystemExceptions::InsufficientFundsError, 'insufficient funds' if budget < amount
    raise BidsystemExceptions::InvalidAmountError, 'invalid amount' if auction.is_bid_amount_invalid?(amount)
    raise BidsystemExceptions::AuctionClosedError, 'auction closed' if auction.closed?
    begin
      bid = auction.create_bid(amount, self)
    rescue
      raise BidsystemExceptions::BidRaceConditionError, 'two users tried to bid at the same time for the same item'
    end
  end

end
