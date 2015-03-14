class RecipeMe.CategoriesController
  constructor: ->
    @categories = new RecipeMe.Collections.Categories()
    @categories.fetch({reset: true, async: false})

  index: ->
    view = new RecipeMe.Views.CategoryIndex({collection: @categories})
    $("section#main").html(view.el)
    view.render()