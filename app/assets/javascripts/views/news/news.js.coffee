class RecipeMe.Views.News extends Backbone.View
  template: JST["news/news"]
  className: "news-item col-md-8"
  events:
    'click .destroy-news': 'destroyNews'

  initialize: (params) ->
    if params.model
      @news = params.model

  destroyNews: (event) ->
    @news.destroy({async: false})
    $(event.target).closest(".news-item").fadeOut('slow')

  render: ->
    $(@el).html(@template(news: @news))
    this
