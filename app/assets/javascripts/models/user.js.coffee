class RecipeMe.Models.User extends Backbone.Model
  urlRoot: '/api/users'
  paramRoot: 'user'

  parse: (response) ->
    return response
