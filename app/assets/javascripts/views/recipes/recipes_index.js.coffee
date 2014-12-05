class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template(recipes: @collection))
    this
