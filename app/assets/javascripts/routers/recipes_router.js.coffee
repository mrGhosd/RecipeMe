class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'rescipes/new': 'new'

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
