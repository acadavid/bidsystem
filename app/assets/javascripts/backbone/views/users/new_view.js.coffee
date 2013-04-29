Bidsystem.Views.Users ||= {}

class Bidsystem.Views.Users.NewView extends Backbone.View
  template: JST["backbone/templates/users/new"]

  events:
    "submit #new-user": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (user) =>
        @model = user
        window.location.hash = "#/index"

      error: (user, jqXHR) =>
        errors_json = $.parseJSON(jqXHR.responseText)
        @model.set({errors: errors_json.errors})

      wait: true
      )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$('form').html(window.JST['backbone/templates/users/_form'](@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
