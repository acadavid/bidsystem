class Auction < ActiveRecord::Base
  belongs_to :user
  attr_accessible :active, :current_price, :item_name

  validates :current_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :active, inclusion: { in: [true, false] }

  delegate :name, to: :user, :prefix => :auctioner
end
