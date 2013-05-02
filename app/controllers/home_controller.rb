class HomeController < ApplicationController

  def index
    @users = User.all
    @auctions = Auction.all
  end

end
