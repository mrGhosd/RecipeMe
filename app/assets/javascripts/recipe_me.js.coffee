window.RecipeMe =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new RecipeMe.Routers.Recipes()
    Backbone.history.start()

$(document).ready ->
  RecipeMe.initialize()
