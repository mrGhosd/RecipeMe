class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
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

  index: ->
    this.setup()
    view = new RecipeMe.Views.RecipesIndex(collection: @collection)
    $("section#main").html(view.el)
    view.render()

  newRecipe: ->
    this.setup()
    view = new RecipeMe.Views.RecipesForm(collection: @collection)
    $("section#main").html(view.el)
    view.render()

  showRecipe: (id) ->
    this.setup()
    alert "This will be a show template"

  editRecipe: (id) ->
    this.setup()
    recipe = @collection.at(12)
    console.log recipe
    view = new RecipeMe.Views.RecipesForm()
    $("section#main").html(view.el)
    view.render()
