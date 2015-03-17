class RecipeMe.Views.CallbackIndex extends Backbone.View
  template: JST["callbacks/index"]

  initialize: ->
    @collection = new RecipeMe.Collections.Callbacks()
    @collection.fetch({async: false})
    @collection.on('add', @render, this)
    @collection.on('remove', @render, this)

  render: ->
    $(@el).html(@template())
    this