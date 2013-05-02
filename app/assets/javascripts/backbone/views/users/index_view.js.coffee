Bidsystem.Views.Users ||= {}

class Bidsystem.Views.Users.IndexView extends Backbone.View
  template: JST["backbone/templates/users/index"]

  initialize: () ->
    @options.users.bind('reset', @render)

  addAll: () =>
    @options.users.each(@addOne)

  addOne: (user) =>
    view = new Bidsystem.Views.Users.UserView({model : user})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(users: @options.users.toJSON() ))
    @addAll()

    return this
