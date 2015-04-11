class RecipeMe.Views.NewsIndex extends Backbone.View
  template: JST["news/index"]
  className: "news-main"

  initialize: (params) ->
    @page = 1
    @collection = params.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  addNews: (model) ->
    view = new RecipeMe.Views.News({model: model})
    $(".news-list").prepend(view.render().el)

  successNewsUpload: (response, request) ->
    for model in response
      news = new RecipeMe.Models.New(model)
      view = new RecipeMe.Views.News(model: news)
      $(".news-main .news-list").append(view.render().el)

  render: ->
    $(@el).html(@template())
    @collection.each(@addNews)
    window.scrollUpload.init(@page, "api/news", $(".news-main .news-list"), this.successNewsUpload)
    this