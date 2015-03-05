class RecipeMe.Collections.Recipes extends Backbone.Collection
  url: '/api/recipes'
  model: RecipeMe.Models.Recipe

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

