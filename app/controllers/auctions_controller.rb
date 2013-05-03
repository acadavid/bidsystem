class AuctionsController < ApplicationController

  respond_to :json

  before_filter :get_user, only: :create

  def show
    @auction = Auction.find(params[:id])
    render json: @auction.to_json({methods: [:auctioner_name, :winning_bidder_name, :winner_name]})
  end

  def create
    @auction = @user.auctions.build(params[:auction])

    if @auction.save
      render json: @auction.to_json({methods: [:auctioner_name, :winning_bidder_name, :winner_name]}), status: :created
    else
      render_object_errors(@auction)
    end
  end

  def update
    @auction = Auction.find(params[:id])

    if params[:auction][:active] == false
      handle_closing(@auction)
      return
    end

    if @auction.update_attributes(params[:auction])
      head :no_content
    else
      render_object_errors(@auction)
    end
  end

  def destroy
    @auction = Auction.find(params[:id])
    @auction.destroy

    head :no_content
  end

  private

  def handle_closing(auction)
    if auction.close!
      head :no_content
    else
      render_object_errors(auction)
    end
  end

  def get_user
    # I'm preventing mass assigment in the auctions to keep model clean
    # and simplify the application development in backbone
    # but usually this should be handled in a more secure way.
    @user = User.find(params[:auction][:user_id])
    params[:auction].delete(:user_id)
  end

end
