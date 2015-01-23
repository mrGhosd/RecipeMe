class RecipeMe.Collections.Recipes extends Backbone.Collection
  url: '/api/recipes'
  model: RecipeMe.Models.Recipe

  currentUserRecipes: ->
    recipes = []
    $.each(this.models,
      (key, value)->
        if value.get("user_id") == RecipeMe.currentUser.get("id")
          recipes.push(value)
   )
    return recipes

  defaults:
    title: null
    image: null

