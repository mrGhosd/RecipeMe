class RecipeMe.Models.User extends Backbone.Model
  urlRoot: '/api/users'
  fileAttribute: 'avatar'

  parse: (response) ->
    recipes = new RecipeMe.Collections.Recipes({user: response.id})
    recipes.fetch()
    response["recipes"] = recipes
    return response
