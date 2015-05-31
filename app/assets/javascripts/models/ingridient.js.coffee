class RecipeMe.Models.Ingridient extends Backbone.Model

  initialize: (params) ->
    if params && params.recipe
      @recipe = params.recipe
    else
      @recipe = undefined

  url: ->
    if @recipe
      return "api/recipes/#{@recipe}/ingridients"
    else
      return "api/ingridients"
