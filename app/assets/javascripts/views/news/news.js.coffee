class RecipeMe.Views.News extends Backbone.View
  template: JST["news/news"]
  className: "news-item col-md-8"
  initialize: (params) ->
    if params.model
      @news = params.model

  render: ->
    $(@el).html(@template(news: @news))
    this
