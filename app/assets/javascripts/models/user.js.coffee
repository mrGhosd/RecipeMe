class RecipeMe.Models.User extends Backbone.Model
#  urlRoot: '/api/users'
  fileAttribute: 'avatar'

  initialize: (options) ->
    @params = options
#    this.url()
#    this.fetch().done ->
#      console.log this

  url: ->
    if @params.id
      return "/api/users/#{@params.id}"
    else
      return "/api/users"

  parse: (response) ->
    recipes = new RecipeMe.Collections.Recipes({user: response.id})
    recipes.fetch()
    response["recipes"] = recipes
    return response
