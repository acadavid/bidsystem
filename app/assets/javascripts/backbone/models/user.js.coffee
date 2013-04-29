class Bidsystem.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null
    budget: null

  toJSON: ->
    attrs = _(this.attributes).clone()
    delete attrs.created_at
    delete attrs.updated_at
    return attrs

class Bidsystem.Collections.UsersCollection extends Backbone.Collection
  model: Bidsystem.Models.User
  url: '/users'
