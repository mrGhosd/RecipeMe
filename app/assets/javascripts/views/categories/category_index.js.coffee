class RecipeMe.Views.CategoryIndex extends Backbone.View
  template: JST["categories/index"]

  initialize: (params) ->
    if params.collection
      @collection = params.collection
      @collection.on('reset', @render, this)
      @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template)
    @collection.each(@addCategory)
    this

  addCategory: (category) ->
    console.log category
    view = new RecipeMe.Views.Category(model: category)
    $(".categories-list").prepend(view.render().el)
