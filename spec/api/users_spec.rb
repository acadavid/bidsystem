require 'spec_helper'

describe "/users" do
  include Rack::Test::Methods

  let(:params) { {:user => FactoryGirl.attributes_for(:user)} }

  let(:invalid_params) {
    {:user => {
      :name => "John Doe",
      :email => "john@doe.com",
      :budget => -50,
      }
    }
 }

  it "should create a user and return a success status" do
    post "/users", params
    last_response.status.should eql(201)
    user = User.last

    expect(user.name).to eql(params[:user][:name])
    expect(user.email).to eql(params[:user][:email])
    expect(user.budget).to eql(params[:user][:budget])
  end

  it "should create a user with correct budget" do
    post "/users", params
    last_response.status.should eql(201)
    user = User.last

    expect(user.budget).to eql(params[:user][:budget])
  end

  it "should return an error message if it can't be created" do
    post "/users", invalid_params
    last_response.status.should eql(422)
    response = JSON.parse(last_response.body)

    expect(response["errors"]).not_to be_empty
  end

end
