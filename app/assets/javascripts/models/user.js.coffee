class RecipeMe.Models.User extends Backbone.Model
  urlRoot: '/api/users'
  fileAttribute: 'avatar'

  parse: (response) ->
    return response
