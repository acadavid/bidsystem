class User < ActiveRecord::Base
  attr_accessible :budget, :email, :name

  validates :name, presence: true
  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :auctions, dependent: :destroy
end
