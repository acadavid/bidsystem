require 'spec_helper'

describe Auction do
  context "validations" do
    it "should be invalid without a price" do
      auc = FactoryGirl.build(:auction, current_price: nil)
      expect(auc).to have(2).errors_on(:current_price)
      expect(auc).not_to be_valid
    end
    
    it "should be invalid without a positive price" do
      auc = FactoryGirl.build(:auction, current_price: -1)
      expect(auc).to have(1).error_on(:current_price)
      expect(auc).not_to be_valid
    end
    
    it "should be invalid with a price of 0" do
      auc = FactoryGirl.build(:auction, current_price: 0)
      expect(auc).to have(1).error_on(:current_price)
      expect(auc).not_to be_valid
    end

    it "should be invalid without an active state" do
      auc = FactoryGirl.build(:auction, active: nil)
      expect(auc).to have(1).error_on(:active)
      expect(auc).not_to be_valid
    end

    it "should be valid with an false active state" do
      auc = FactoryGirl.build(:auction, active: false)
      expect(auc).to be_valid
    end
  end

  context "users interactions" do
    it "should be able to have a poster user associated" do
      auc = FactoryGirl.build(:auction)
      auc.should respond_to(:user)
    end

    it "should be able to have bidders (user) associated" do
      auc = FactoryGirl.build(:auction)
      auc.should respond_to(:bidders)
    end
  end

  it "should tell if a bid amount is invalid with respect to the current_price" do
    auc = FactoryGirl.build(:auction)
    bid_amount = auc.current_price - 20
    auc.is_bid_amount_invalid?(bid_amount).should be_true
  end

  it "should tell if an auction is closed" do
    auc = FactoryGirl.build(:auction, active: false)
    auc.closed?.should be_true
  end

  it "should return the highest bid" do
    auc = FactoryGirl.build(:auction_with_auctioner, current_price: 100)
    bidder1 = FactoryGirl.create(:user, budget: 300)
    bidder2 = FactoryGirl.create(:user, budget: 300)
    bid_bidder1 = bidder1.bid(auc, auc.current_price+20)
    bid_bidder2 = bidder2.bid(auc, auc.current_price+30)
    expect(auc.highest_bid).to be_an_instance_of(Bid)
    expect(auc.highest_bid).to eql(bid_bidder2)
  end

end
