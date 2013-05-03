class Bidsystem.Models.Auction extends Backbone.Model
  paramRoot: 'auction'

  defaults:
    item_name: null
    current_price: null


class Bidsystem.Collections.AuctionsCollection extends Backbone.Collection
  model: Bidsystem.Models.Auction
  url: '/auctions'
