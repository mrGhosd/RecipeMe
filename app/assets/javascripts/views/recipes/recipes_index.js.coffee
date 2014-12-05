class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  initialize: ->
    console.log "1"
    @collection.on('reset', @render, this)

  render: ->
    console.log "2"
    console.log @collection
    $(@el).html(@template(recipes: @collection))
    this
