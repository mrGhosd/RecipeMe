class RecipeMe.Views.NewsIndex extends Backbone.View
  template: JST["news/index"]
  className: "news-main"

  initialize: (params) ->
    @collection = params.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  addNews: (model) ->
    view = new RecipeMe.Views.News({model: model})
    console.log view
    $(".news-list").prepend(view.render().el)

  render: ->
    $(@el).html(@template())
    @collection.each(@addNews)
    this