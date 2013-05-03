require 'spec_helper'
require 'bidsystem_exceptions'

describe User do
  context "validations" do
    it "should be invalid without a name" do
      user = FactoryGirl.build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "should be invalid without a budget" do
      user = FactoryGirl.build(:user, budget: nil)
      expect(user).not_to be_valid
    end

    it "should be invalid without a positive budget" do
      user = FactoryGirl.build(:user, budget: -1)
      expect(user).not_to be_valid
    end

    it "should be valid with a budget of 0" do
      user = FactoryGirl.build(:user, budget: 0)
      expect(user).to be_valid
    end

    it "should be valid with a huge budget" do
      user = FactoryGirl.build(:user, budget: 50000000)
      expect(user).to be_valid
    end
  end

  context "auctions" do
    it "should be able to have auctions" do
      user = FactoryGirl.build(:user)
      user.should respond_to(:auctions)
    end

    it "should be able to create auctions" do
      user = FactoryGirl.create(:user)
      expect {
        user.auctions.create(FactoryGirl.attributes_for(:auction))
      }.to change{user.auctions.size}.by 1
    end
  end

  context "bidding" do
    it "should be able to have bids" do
      user = FactoryGirl.build(:user)
      user.should respond_to(:bids)
    end

    it "should be able to bid on an auction and return a Bid object" do
      auction = FactoryGirl.create(:auction_with_auctioner)
      bidder = FactoryGirl.create(:user)
      amount = 100
      expect(bidder.bid(auction, amount)).to be_an_instance_of(Bid)
    end

    it "should block the bid's amount from the user's budget" do
      auction = FactoryGirl.create(:auction_with_auctioner, :current_price => 100)
      bidder = FactoryGirl.create(:user, budget: 1000)
      bidder.bid(auction, 200)
      expect(bidder.blocked_budget).to eq(200)
      expect(bidder.budget).to eq(800)
    end

    it "should raise InsufficientFundsError  if user's budget is lower than bid amount" do
      auction = FactoryGirl.create(:auction_with_auctioner)
      bidder = FactoryGirl.create(:user)
      amount = bidder.budget + 10
      expect {bidder.bid(auction, amount) }.to raise_error(BidsystemExceptions::InsufficientFundsError)
    end

    it "should raise InvalidAmountError exception if amount is lower than current's auction price" do
      auction = FactoryGirl.create(:auction_with_auctioner)
      bidder = FactoryGirl.create(:user)
      amount = auction.current_price - 10
      expect {bidder.bid(auction, amount) }.to raise_error(BidsystemExceptions::InvalidAmountError)
    end

    it "should raise AuctionClosedError exception if the auction is already closed" do
      auction = FactoryGirl.create(:auction_with_auctioner, active: false)
      bidder = FactoryGirl.create(:user)
      amount = auction.current_price + 10
      expect {bidder.bid(auction, amount) }.to raise_error(BidsystemExceptions::AuctionClosedError)
    end

    it "should be able to retrive only its winning bids" do
      bidder = FactoryGirl.create(:user, budget: 500)
      auction1 = FactoryGirl.create(:auction_with_auctioner)
      auction2 = FactoryGirl.create(:auction_with_auctioner)
      bidder.bid(auction1, auction1.current_price+20)
      bidder.bid(auction2, auction1.current_price+20)
      auction2.active = false
      auction2.save
      expect(bidder.bids.count).to eq(2)
      expect(bidder.winning_auctions.count).to eq(1)
    end

    it "should tell if has the winning bid for a given auction" do
      auction = FactoryGirl.create(:auction_with_auctioner)
      bidder1 = FactoryGirl.create(:user, budget: 500)
      bidder2 = FactoryGirl.create(:user, budget: 500)
      bidder1.bid(auction, auction.current_price+20)
      bidder2.bid(auction, auction.current_price+30)
    end

    it "should allow me to bid if the amount of the bid is not available in my immediate budget" do
      bidder = FactoryGirl.create(:user, budget: 500)
      initial_budget = bidder.budget
      auction1 = FactoryGirl.create(:auction_with_auctioner, current_price: 300)
      auction2 = FactoryGirl.create(:auction_with_auctioner, current_price: 300)
      amount_to_bid1 = auction1.current_price+100
      amount_to_bid2 = auction2.current_price+100
      bidder.bid(auction1, amount_to_bid1)
      expect { bidder.bid(auction2, amount_to_bid2) }.to raise_error(BidsystemExceptions::InsufficientFundsError)
      expect(bidder.budget).to eql(initial_budget - amount_to_bid1)
    end

    it "should return my money to my budget if i'm not winning the auction anymore" do
      initial_budget = 1000
      bidder1 = FactoryGirl.create(:user, budget: initial_budget)
      bidder2 = FactoryGirl.create(:user, budget: initial_budget)
      auction = FactoryGirl.create(:auction_with_auctioner, current_price: 300)
      bid_amount = auction.current_price+100 # 400
      bidder1.bid(auction, bid_amount)
      expect {
        bidder2.bid(auction, bid_amount+200)
      }.to change { bidder1.budget }.from(initial_budget - bid_amount).to(initial_budget)
    end
  end


  context "budget operations" do
    it "should return false if withdrawal can't be done" do
      user = FactoryGirl.build(:user)
      expect(user.withdrawal!(1000)).to be_false
    end

    it "should not withdraw money if user's budget is less than the amount to withdraw" do
      user = FactoryGirl.build(:user)
      initial_budget = user.budget
      user.withdrawal!(1000)
      expect(user.budget).to eq(initial_budget)
    end

    it "should correctly withdraw money when the budget allows it" do
      user = FactoryGirl.build(:user)
      initial_budget = user.budget
      amount = 30
      expect{
        user.withdrawal!(amount)
      }.to change{user.budget}.from(initial_budget).to(initial_budget - amount)
    end

    it "should return false if deposit can't be done" do
      user = FactoryGirl.build(:user)
      expect(user.deposit!(-30)).to be_false
    end

    it "should not modify its budget if a negative amount was deposited" do
      user = FactoryGirl.build(:user)
      initial_budget = user.budget
      amount = -30
      user.deposit!(amount)
      expect(user.budget).to eq(initial_budget)
    end

    it "should be able to receive a deposit and update its budget" do
      user = FactoryGirl.build(:user)
      initial_budget = user.budget
      amount = 30
      expect{
        user.deposit!(amount)
      }.to change{user.budget}.from(initial_budget).to(initial_budget + amount)
    end

    it "should correctly block my budget after bids" do
      user = FactoryGirl.create(:user, budget: 500)
      auction = FactoryGirl.create(:auction_with_auctioner, current_price: 50)

      expect{
        user.bid(auction, 70)
      }.to change {user.budget}.from(500).to(430)
    end
  end

  context "won auctions" do
    it "should list the won auctions" do
      user = FactoryGirl.create(:user, budget: 300)
      auc1 = FactoryGirl.build(:auction)
      auc2 = FactoryGirl.build(:auction)
      user.bid(auc1, auc1.current_price+20)
      user.bid(auc2, auc2.current_price+30)
      auc1.close!
      auc2.close!
      expect(user.won_auctions).to include(auc1, auc2)
    end
  end

end
