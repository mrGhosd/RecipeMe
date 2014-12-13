class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'recipes/page/:page': 'index'
    'recipes/new': 'newRecipe'
    'recipes/:id': 'showRecipe'
    'recipes/:id/edit': 'editRecipe'

  initialize: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch()

  application: ->
    this.setup()

  setup: ->
    if(!this.ApplicationView)
      new RecipeMe.Views.ApplicationView({el: 'body'})

  index: (page) ->
    p = (if page then parseInt(page, 10) else 1)
    this.setup()
    console.log @collection
    @collection.fetch({reset: true})
    view = new RecipeMe.Views.RecipesIndex({collection: @collection, page: p})
    $("section#main").html(view.el)
    view.render()

  newRecipe: ->
    this.setup()
    view = new RecipeMe.Views.RecipesForm({collection: @collection, type: "POST"})
    $("section#main").html(view.el)
    view.render()

  showRecipe: (id) ->
    this.setup()
    alert "This will be a show template"

  editRecipe: (id) ->
    this.setup()
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipesForm({model: model, type: 'PUT'})
        $("section#main").html(view.el)
        view.render()
