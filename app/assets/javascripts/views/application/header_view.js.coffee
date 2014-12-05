class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this