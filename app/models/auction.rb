class Auction < ActiveRecord::Base
  belongs_to :user
  attr_accessible :active, :current_price, :item_name

  validates :current_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :active, inclusion: { in: [true, false] }

  has_many :bids, dependent: :destroy
  has_many :bidders, through: :bids, source: :user
  has_many :bidders, through: :bids, source: :user
  belongs_to :highest_bid, class_name: "Bid", foreign_key: "highest_bid_id"

  delegate :name, to: :user, prefix: :auctioner
  delegate :name, to: :winning_bidder, prefix: :winning_bidder, allow_nil: true

  def is_bid_amount_invalid?(amount)
    current_price > amount
  end

  def closed?
    !active
  end

  def winning_bidder
    return nil if highest_bid.nil?
    highest_bid.user
  end

  def create_bid(amount, user)
    self.transaction do
      bid = Bid.new
      bid.amount = amount
      bid.user = user
      self.current_price = bid.amount
      self.highest_bid = bid
      self.bids << bid
      bid.save
      save
      bid
    end
  end

end
