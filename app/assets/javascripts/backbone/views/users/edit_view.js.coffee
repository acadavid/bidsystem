Bidsystem.Views.Users ||= {}

class Bidsystem.Views.Users.EditView extends Backbone.View
  template : JST["backbone/templates/users/edit"]

  events :
    "submit #edit-user" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @model.save(null,
      success : (user) =>
        @model = user
        window.location.hash = ""

      error: (user, jqXHR) =>
        errors_json = $.parseJSON(jqXHR.responseText)
        @model.set({errors: errors_json.errors})
        this.render()

      wait: true
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    this.$('form').html(window.JST['backbone/templates/users/_form'](@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
