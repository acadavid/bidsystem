class Bidsystem.Routers.BidsystemRouter extends Backbone.Router
  initialize: (options) ->
    @users = options.users
    @auctions = options.auctions

  routes:
    "users/new"      : "newUser"
    "users/:id/edit" : "editUser"
    "users/:id/login" : "loginUser"
    "auctions/new"      : "newAuction"
    ".*"        : "index"

  newUser: ->
    @view = new Bidsystem.Views.Users.NewView(collection: @users)
    $("#users").html(@view.render().el)

  editUser: (id) ->
    user = @users.get(id)

    @view = new Bidsystem.Views.Users.EditView(model: user)
    $("#users").html(@view.render().el)

  newAuction: ->
    @view = new Bidsystem.Views.Auctions.NewView(collection: @auctions)
    $("#auctions").html(@view.render().el)

  showAuction: (id) ->
    auction = @auctions.get(id)

    @view = new Bidsystem.Views.Auctions.ShowView(model: auction)
    $("#auctions").html(@view.render().el)

  index: ->
    @users_view = new Bidsystem.Views.Users.IndexView(users: @users)
    @auctions_view = new Bidsystem.Views.Auctions.IndexView(auctions: @auctions)
    $("#auctions").html(@auctions_view.render().el)
    $("#users").html(@users_view.render().el)

  loginUser: (id) ->
    user = @users.get(id)
    window.Bidsystem.ActiveUser = user
    @users_view = new Bidsystem.Views.Users.IndexView(users: @users)
    @auctions_view = new Bidsystem.Views.Auctions.IndexView(auctions: @auctions)
    $("#auctions").html(@auctions_view.render().el)
    $("#users").html(@users_view.render().el)
