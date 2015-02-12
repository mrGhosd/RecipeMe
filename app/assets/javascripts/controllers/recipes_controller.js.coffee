class RecipeMe.RecipesController
  index: ->
    collection = new RecipeMe.Collections.Recipes()
    collection.fetch({reset: true})
    view = new RecipeMe.Views.RecipesIndex({collection: collection})
    $("section#main").html(view.el)
    view.render()