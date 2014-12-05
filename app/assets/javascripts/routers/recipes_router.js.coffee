class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'rescipes/:id': 'show'

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
    $("section#main").html(view.render().el)
#
#  recipeIndex: ->
#    this.setup()
##    new RecipeMe.Views.RecipesIndex({el: 'section#main'})
#
#  show:(id) ->
#    alert "Recipe #{id}"