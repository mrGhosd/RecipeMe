class RecipeMe.CategoriesController
  constructor: ->
    @categories = new RecipeMe.Collections.Categories()
    @categories.fetch({reset: true, async: false})

  index: ->
    view = new RecipeMe.Views.CategoryIndex({collection: @categories})
    $("section#main").html(view.el)
    view.render()

  new: ->
    model = new RecipeMe.Models.Category()
    view = new RecipeMe.Views.CategoryForm(model: model)
    $("section#main").html(view.el)
    view.render()

  edit: (id) ->
    category = new RecipeMe.Models.Category(id: id)
    console.log category
    category.fetch
      success: (model)->
        console.log model
        view = new RecipeMe.Views.CategoryForm({model: model})
        $("section#main").html(view.el)
        view.render()