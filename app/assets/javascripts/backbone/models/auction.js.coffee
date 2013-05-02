class Bidsystem.Models.Auction extends Backbone.Model
  paramRoot: 'auction'

  defaults:
    item_name: null
    current_price: null

  toJSON: ->
    attrs = _(this.attributes).clone()
    if (window.Bidsystem.ActiveUser)
      attrs["user_id"] = window.Bidsystem.ActiveUser.id

    return attrs


class Bidsystem.Collections.AuctionsCollection extends Backbone.Collection
  model: Bidsystem.Models.Auction
  url: '/auctions'
