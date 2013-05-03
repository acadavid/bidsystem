Bidsystem.Views.Auctions ||= {}

class Bidsystem.Views.Auctions.AuctionView extends Backbone.View
  template: JST["backbone/templates/auctions/auction"]

  events:
    "click .destroy" : "destroy"
    "click .bid" : "bid"
    "click .close-auction" : "close"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  bid: () ->
    Bid = Backbone.Model.extend
      paramRoot: 'bid'

    Bids = Backbone.Collection.extend
      model: Bid
      url: "/bids"

    bids = new Bids
    bids.create({user_id: window.Bidsystem.ActiveUser.id, auction_id: @model.id, amount: this.$(".amount").val()},
      success: (bid) =>
        window.users.fetch(reset: true)
        self = @
        @model.fetch(
          success: ->
             self.render()
        )

      error: (user, jqXHR) =>
        errors_json = $.parseJSON(jqXHR.responseText)
        alert(errors_json.errors)
    )

    return true

  close: () ->
    self = @
    @model.set({active: false})
    @model.save()
    @model.fetch(
      success: ->
        self.render()
    )

    window.users.fetch(reset: true)

    return true

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
