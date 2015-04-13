class RecipeMe.Views.Forbidden extends Backbone.View
  template: JST["errors/forbidden"]

  initialize: ->

  render: ->
    $(@el).html(@template())
    this