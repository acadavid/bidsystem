Bidsystem.Views.Auctions ||= {}

class Bidsystem.Views.Auctions.AuctionView extends Backbone.View
  template: JST["backbone/templates/auctions/auction"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
