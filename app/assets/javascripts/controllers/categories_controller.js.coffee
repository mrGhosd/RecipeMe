class RecipeMe.CategoriesController

  index: ->
    this.loadCategoriesCollection()
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
    category.fetch
      success: (model)->
        view = new RecipeMe.Views.CategoryForm({model: model})
        $("section#main").html(view.el)
        view.render()

  show: (id) ->
    category = new RecipeMe.Models.Category(id: id)
    category.fetch
      success: (model)->
        view = new RecipeMe.Views.CategoryShow({model: model})
        $("section#main").html(view.el)
        view.render()

  loadCategoriesCollection: ->
    @categories = new RecipeMe.Collections.Categories()
    @categories.fetch({reset: true, async: false})