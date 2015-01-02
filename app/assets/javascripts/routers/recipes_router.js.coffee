class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'recipes/page/:page': 'index'
    'recipes/new': 'newRecipe'
    'recipes/:id': 'showRecipe'
    'recipes/:id/edit': 'editRecipe'
    'users/:id': 'userProfile'
    'users/:id/recipes': 'userRecipes'

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
    view = new RecipeMe.Views.RecipesForm({collection: @collection})
    $("section#main").html(view.el)
    view.render()

  showRecipe: (id) ->
    this.setup()
    recipe = new RecipeMe.Models.Recipe(id: id)

    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipeShow(model: model)
        $("section#main").html(view.el)
        view.render()

  editRecipe: (id) ->
    this.setup()
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipesForm({model: model})
        $("section#main").html(view.el)
        view.render()

  userProfile: (id) ->
    this.setup()
    if RecipeMe.currentUser
      profile = new RecipeMe.Views.UserProfile(user: RecipeMe.currentUser)
      $("section#main").html(profile.el)
      profile.render()
    else
      Backbone.history.navigate('/recipes', {trigger: true, repalce: true})

  userRecipes: ->
    this.setup()
    if RecipeMe.currentUser
      favorites = new RecipeMe.Collections.Recipes(RecipeMe.currentUser.get('recipes'))
      view = new RecipeMe.Views.RecipesIndex(collection: favorites)
      $("section#main").html(view.el)
      view.render()
    else
