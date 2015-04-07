class RecipeMe.Views.FeedRecipe extends Backbone.View
  template: JST['feeds/feed_recipe']
  className: 'recipe-feed-item'

  initialize: (params) ->
    if params.model
      @recipe = params.model

    this.render()

  render: ->
    $(@el).html(@template(recipe: @recipe))
    this