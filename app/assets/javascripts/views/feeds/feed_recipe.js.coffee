class RecipeMe.Views.FeedRecipe extends Backbone.View
  template: JST['feeds/feed_recipe']
  className: 'recipe-feed-item'

  initialize: (params) ->
    if params
      @recipe = params.model
      @icon = params.icon

    this.render()

  render: ->
    $(@el).html(@template(recipe: @recipe, icon: @icon))
    this