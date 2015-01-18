class RecipeMe.Models.User extends Backbone.Model
  urlRoot: '/api/users'
  paramRoot: 'user'
  fileAttribute: 'avatar'

  parse: (response) ->
    return response
