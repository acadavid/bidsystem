class BidsController < ApplicationController

  respond_to :json

  before_filter :get_user, only: :create
  before_filter :get_auction, only: :create

  def create
    begin
      @user.bid(@auction, params[:bid][:amount].to_i)
      render json: {}, status: :created
    rescue Exception => ex
      # TODO: This is dangerous. Just for the sake of simplicity
      # I'm rescuing all the exceptions, but this should be specific.
      render_exception(ex)
    end
  end

  private

  def get_user
    @user = User.find(params[:bid][:user_id])
  end

  def get_auction
    @auction = Auction.find(params[:bid][:auction_id])
  end

  def render_exception(exception)
    render json: {errors: exception.message}, status: :unprocessable_entity
  end
end
