class RecipeMe.Collections.Recipes extends Backbone.Collection
  model: RecipeMe.Models.Recipe

  initialize: (params) ->
    if params
      @category = params.category_id
      @path = params.url

  url: ->
    if @path
      return @path
    if @category
      return "/api/categories/#{@category}/recipes"
    else
      return '/api/recipes'

  userRecipes: (user_id)->
    recipes = []
    $.each(this.models,
      (key, value)->
        if value.get("user_id") == user_id
          recipes.push(value)
    )
    return recipes

  defaults:
    title: null
    image: null

