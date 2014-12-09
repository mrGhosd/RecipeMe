class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'recipes/new': 'newRecipe'
    'recipes/:id': 'showRecipe'
    'recipes/:id/edit': 'editRecipe'

  initialize: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch({reset: true})


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

  showRecipe: ->
    this.setup()
    alert "This will be a show template"

  editRecipe: ->
    this.setup()
    alert "this will be a edit template"
