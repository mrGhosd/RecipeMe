window.RecipeMe =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new RecipeMe.Routers.Recipes()
    Backbone.history.start({pushState: true})

$(document).ready ->
  RecipeMe.initialize()
