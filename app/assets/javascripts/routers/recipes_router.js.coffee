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
    'users/:id/edit': 'editProfile'
    'categories': 'categoriesList'
    'categories/new': 'createCategory'
    'categories/:id/edit': 'editCategory'
    'categories/:id': 'showCategory'
    'callbacks': 'callbacksList'
    'news': 'newsList'

  initialize: ->
    this.setup()
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch()
    RecipeMe.recipesCollection = @collection

  application: ->
    this.index()

  setup: ->
    if(!this.ApplicationView)
      new RecipeMe.Views.ApplicationView({el: 'body'})

  index:->
    new RecipeMe.RecipesController().index()

  newRecipe: ->
    new RecipeMe.RecipesController().new()

  showRecipe: (id) ->
    new RecipeMe.RecipesController().show(id)

  editRecipe: (id) ->
    new RecipeMe.RecipesController().edit(id)

  userProfile: (id) ->
    new RecipeMe.UsersController().show(id)

  categoriesList: ->
    new RecipeMe.CategoriesController().index()

  createCategory: ->
    new RecipeMe.CategoriesController().new()

  editCategory: (id) ->
    new RecipeMe.CategoriesController().edit(id)

  showCategory: (id) ->
    new RecipeMe.CategoriesController().show(id)

  callbacksList: ->
    view = new RecipeMe.Views.CallbackIndex()
    $("section#main").html(view.el)
    view.render()

  newsList: ->
    new RecipeMe.NewsController().index()

  userRecipes: (id) ->
    if RecipeMe.currentUser
      user_recipes = new RecipeMe.Collections.Recipes(@collection.currentUserRecipes())
      view = new RecipeMe.Views.RecipesIndex({collection: user_recipes})
      $("section#main").html(view.el)
      view.render()
    else

  editProfile: (id) ->
    if RecipeMe.currentUser
      view = new RecipeMe.Views.EditProfile
      $("section#main").slideUp()
      $("section#main").html(view.el).slideDown()
      view.render()
