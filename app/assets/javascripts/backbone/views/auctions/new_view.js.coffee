Bidsystem.Views.Auctions ||= {}

class Bidsystem.Views.Auctions.NewView extends Backbone.View
  template: JST["backbone/templates/auctions/new"]

  events:
    "submit #new-auction": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    if (window.Bidsystem.ActiveUser)
      @model.set({user_id: window.Bidsystem.ActiveUser.id})

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (auction) =>
        @model = auction
        window.location.hash = ""

      error: (user, jqXHR) =>
        errors_json = $.parseJSON(jqXHR.responseText)
        @model.set({errors: errors_json.errors})

      wait: true
    )

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this.$('form').html(window.JST['backbone/templates/auctions/_form'](@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
