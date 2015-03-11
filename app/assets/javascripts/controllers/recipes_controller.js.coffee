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
        steps = model.get("steps")
        steps.fetch({async: false})
        view = new RecipeMe.Views.RecipeShow(model: model, steps: steps)
        $("section#main").html(view.el)
        view.render()

  edit: (id) ->
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipesForm({model: model})
        $("section#main").html(view.el)
        view.render()
