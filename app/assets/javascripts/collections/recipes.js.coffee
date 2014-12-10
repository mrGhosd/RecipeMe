class RecipeMe.Collections.Recipes extends Backbone.Collection
  url: '/api/recipes'
  model: RecipeMe.Models.Recipe

  defaults:
    title: null
    image: null

