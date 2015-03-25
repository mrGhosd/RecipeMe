class RecipeMe.Models.Ingridient extends Backbone.Model

  initialize: (params) ->
    if params.recipe
      @recipe = params.recipe

  url: ->
    if @recipe
      return "api/recipes/#{@recipe}/ingridients"
    else
      return "api/ingridients"
