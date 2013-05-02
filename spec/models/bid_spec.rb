require 'spec_helper'

describe Bid do
  context "validations" do
    it "should be invalid without an amount" do
      bid = FactoryGirl.build(:bid, amount: nil)
      expect(bid).to have(2).errors_on(:amount)
      expect(bid).not_to be_valid
    end

    it "should be invalid without a positive amount" do
      bid = FactoryGirl.build(:bid, amount: -1)
      expect(bid).to have(1).error_on(:amount)
      expect(bid).not_to be_valid
    end

    it "should be invalid with a amount of 0" do
      bid = FactoryGirl.build(:bid, amount: 0)
      expect(bid).to have(1).error_on(:amount)
      expect(bid).not_to be_valid
    end
  end

  context "auctions" do
    it "should be able to have an auction associated" do
      bid = FactoryGirl.build(:bid)
      bid.should respond_to(:auction)
    end

    it "should be able to have a winning auction associated" do
      bid = FactoryGirl.build(:bid)
      bid.should respond_to(:winning_auction)
    end
  end

  context "users" do
    it "should be able to have a user associated" do
      bid = FactoryGirl.build(:bid)
      bid.should respond_to(:user)
    end
  end
end
