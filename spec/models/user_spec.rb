require 'spec_helper'

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
end
