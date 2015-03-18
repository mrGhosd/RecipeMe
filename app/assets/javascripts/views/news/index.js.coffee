class RecipeMe.Views.NewsIndex extends Backbone.View
  template: JST["news/index"]
  className: "news-main"

  initialize: (params) ->
    if params.collection
      @collection = params.collection

  render: ->
    $(@el).html(@template())
    this