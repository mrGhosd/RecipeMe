class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'index'

  initialize: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch({reset: true})

  index: ->
    view = new RecipeMe.Views.RecipesIndex(collection: @collection)
    $("#container").html(view.render().el)