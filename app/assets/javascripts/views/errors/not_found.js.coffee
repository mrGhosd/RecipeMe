class RecipeMe.Views.NotFound extends Backbone.View
  template: JST["errors/not_found"]
  initialize: ->

  render: ->
    $(@el).html(@template())
    this