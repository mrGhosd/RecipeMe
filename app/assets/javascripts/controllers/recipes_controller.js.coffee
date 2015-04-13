class RecipeMe.RecipesController
  constructor: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch({reset: true})

  index: ->
    view = new RecipeMe.Views.RecipesIndex({collection: @collection})
    $("section#main").html(view.el)
    view.render()

  new: ->
    view = new RecipeMe.Views.RecipesForm({collection: @collection})
    $("section#main").html(view.el)
    view.render()

  show: (id) ->
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipeShow(model: model)
        $("section#main").html(view.el)
        view.render()
      error: (response, request) ->
        errorMessage = new RecipeMe.ErrorHandler(response, request)
        if errorMessage.status == 404
          errorMessage.status404()

  edit: (id) ->
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model) ->
        if model.get("user_id") == RecipeMe.currentUser.get("id")
          view = new RecipeMe.Views.RecipesForm({model: model})
          $("section#main").html(view.el)
          view.render()
        else
          new RecipeMe.ErrorHandler().forbidden()
