class RecipeMe.Collections.Ingridients extends Backbone.Collection
  model: RecipeMe.Models.Ingridient

  initialize: (params) ->
    if params
      @recipe = params.recipe

  url: ->
    if @recipe
      return "api/recipes/#{@recipe}/ingridients"
    else
      return "api/ingridients"

  search: (letters) ->
    return null if letters == " "

    pattern = new RegExp(letters,"gi")
    this.filter (data) ->
      return pattern.test(data.get("name"))
