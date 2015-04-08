class RecipeMe.Views.FeedVote extends Backbone.View
  template: JST['feeds/feed_vote']
  className: 'recipe-feed-item'

  initialize: (params) ->
    if params.model
      @recipe = params.model

    this.render()

  render: ->
    $(@el).html(@template(recipe: @recipe))
    this