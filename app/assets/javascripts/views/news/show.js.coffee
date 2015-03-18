class RecipeMe.Views.NewsShow extends Backbone.View
  template: JST["news/show"]
  className: "news-show"

  initialize: (params) ->
    if params
      @news = params.model

  render: ->
    $(@el).html(@template(news: @news))
    this