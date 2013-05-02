class AuctionsController < ApplicationController

  respond_to :json

  before_filter :get_user, only: :create

  def create
    @auction = @user.auctions.build(params[:auction])

    if @auction.save
      render json: @auction.to_json({methods: [:auctioner_name]}), status: :created
    else
      render json: {errors: @auction.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

  def update
    @auction = Auction.find(params[:id])

    if @auction.update_attributes(params[:auction])
      head :no_content
    else
      render json: {errors: @auction.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

  def destroy
    @auction = Auction.find(params[:id])
    @auction.destroy

    head :no_content
  end

  private

  def get_user
    # I'm preventing mass assigment in the auctions to keep model clean
    # and simplify the application development in backbone
    # but usually this should be handled in a more secure way.
    @user = User.find(params[:auction][:user_id])
    params[:auction].delete(:user_id)
  end

end
