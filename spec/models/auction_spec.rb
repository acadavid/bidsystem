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
  end

end
