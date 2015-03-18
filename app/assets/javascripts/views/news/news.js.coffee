class RecipeMe.Views.News extends Backbone.View

  initialize: (params) ->
    if params.model
      @news = params.model

  render: ->
    $(@el).html(@template())
    this
