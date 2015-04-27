window.RecipeMe =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    @recipes = new RecipeMe.Routers.Recipes()
    Backbone.history.start({pushState: true})
    this.realtime.connect()

$(document).ready ->
  RecipeMe.initialize()

$(document).on 'page:load', ->
  Backbone.history.stop()
  RecipeMe.initialize()
