Bidsystem.Views.Auctions ||= {}

class Bidsystem.Views.Auctions.ShowView extends Backbone.View
  template: JST["backbone/templates/auctions/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
