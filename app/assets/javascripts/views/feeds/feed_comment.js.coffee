class RecipeMe.Views.FeedComment extends Backbone.View
  template: JST['feeds/feed_comment']
  className: 'comment-feed-item'

  initialize: (params) ->
    if params
      @comment = params.model
      @icon = params.icon
      @recipe = params.recipe

    this.render()

  render: ->
    $(@el).html(@template(comment: @comment, recipe: @recipe, icon: @icon))
    this