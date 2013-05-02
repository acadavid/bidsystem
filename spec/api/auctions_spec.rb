require 'spec_helper'

describe "/auctions" do
  include Rack::Test::Methods

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  let(:params) {
    {auction: {
       user_id: 1,
       item_name: "book",
       current_price: 10 
      }
    }
  }

  let(:invalid_params) {
    {auction: {
       user_id: 1,
       item_name: "book",
       current_price: -10 
      }
    }
  }

  it "should create an auction and return a success status" do
    post "/auctions", params
    last_response.status.should eql(201)
    response = JSON.parse(last_response.body)

    expect(Auction.last.user_id).to eql(1)
    expect(Auction.last.item_name).to eql(params[:auction][:item_name])
    expect(Auction.last.current_price).to eql(params[:auction][:current_price])
  end

  it "should return an error message if it can't be created" do
    post "/auctions", invalid_params
    last_response.status.should eql(422)
    response = JSON.parse(last_response.body)
    auction = Auction.find_by_item_name(invalid_params[:item_name])

    expect(auction.present?).to be_false
    expect(response["errors"]).not_to be_empty
  end

end
