class RecipeMe.Collections.Recipes extends Backbone.Collection
  model: RecipeMe.Models.Recipe

  initialize: (category_id) ->
    @category = category_id if category_id

  url: ->
    if @category
      "/api/categories/#{@category}/recipes"
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

