Bidsystem.Views.Auctions ||= {}

class Bidsystem.Views.Auctions.IndexView extends Backbone.View
  template: JST["backbone/templates/auctions/index"]

  initialize: () ->
    @options.auctions.bind('reset', @addAll)

  addAll: () =>
    @options.auctions.each(@addOne)

  addOne: (auction) =>
    view = new Bidsystem.Views.Auctions.AuctionView({model : auction})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(auctions: @options.auctions.toJSON()))
    @addAll()

    return this
