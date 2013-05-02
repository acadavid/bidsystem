require 'spec_helper'

describe "/bid" do
  include Rack::Test::Methods

  before(:each) do
    @user = FactoryGirl.create(:user)
    @auction = FactoryGirl.create(:auction_with_auctioner)
  end

  let(:params) {
    {
      bid: {
        user_id: @user.id,
        auction_id: @auction.id,
        amount: @auction.current_price + 10
      }
    }
  }

  let(:low_budget_params) {
    {
      bid: {
        user_id: @user.id,
        auction_id: @auction.id,
        amount: @auction.current_price + 1000000000
      }
    }
  }

  let(:invalid_amount_params) {
    {
      bid: {
        user_id: @user.id,
        auction_id: @auction.id,
        amount: @auction.current_price - 10
      }
    }
  }

  let(:auction_closed) {
    {
      bid: {
        user_id: @user.id,
        auction_id: @auction.id,
        amount: @auction.current_price + 10
      }
    }
  }

  it "should create a bid an return a success status" do
    post "/bids", params
    last_response.status.should eql(201)
    response = JSON.parse(last_response.body)

    expect(Bid.last.amount).to eql(params[:bid][:amount])
    expect(Bid.last.user_id).to eql(params[:bid][:user_id])
    expect(Bid.last.auction_id).to eql(params[:bid][:auction_id])
  end

  it "should display an error if the amount is lower than user's current budget" do
    post "/bids", low_budget_params
    last_response.status.should eql(422)
    response = JSON.parse(last_response.body)

    expect(response["errors"]).to eql("insufficient funds")
  end

  it "should display an error if the amount is lower than the auction current price" do
    post "/bids", invalid_amount_params
    last_response.status.should eql(422)
    response = JSON.parse(last_response.body)

    expect(response["errors"]).to eql("invalid amount")
  end

  it "should display an error if the auction is already closed" do
    @auction.active = false
    @auction.save
    post "/bids", params
    last_response.status.should eql(422)
    response = JSON.parse(last_response.body)

    expect(response["errors"]).to eql("auction closed")
  end

end
