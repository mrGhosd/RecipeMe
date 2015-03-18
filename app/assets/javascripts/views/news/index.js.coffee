class RecipeMe.Views.NewsIndex extends Backbone.View
  template: JST["news/index"]
  className: "news-main"

  initialize: (params) ->
    @collection = params.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template())
    this