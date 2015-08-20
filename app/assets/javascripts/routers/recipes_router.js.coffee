class RecipeMe.Routers.Recipes extends Backbone.Router
  routes:
    '':'application'
    'recipes': 'index'
    'recipes/page/:page': 'index'
    'recipes/new': 'newRecipe'
    'recipes/:id': 'showRecipe'
    'users/:id': 'userProfile'
    'users/:id/followers': 'followersList'
    'users/:id/following': 'followingList'
    'users/:id/feed': 'userFeed'
    'search/tag/:param': 'searchByTag'
    'search/ingridient/:param': 'searchByIngridient'
    'categories': 'categoriesList'
    'categories/new': 'createCategory'
    'categories/:id/edit': 'editCategory'
    'categories/:id': 'showCategory'
    'callbacks': 'callbacksList'
    'news': 'newsList'
    'news/new': 'newNews'
    'news/:id': 'showNews'
    'news/:id/edit': 'editNews'

  initialize: ->
    this.setup()

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

  followersList: (id) ->
    new RecipeMe.UsersController().followers(id)

  followingList: (id) ->
    new RecipeMe.UsersController().following(id)

  userFeed: (id) ->
    new RecipeMe.UsersController().userFeed(id)

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

  searchByTag: (param) ->
    search = new RecipeMe.SearchController(param, "tag")
    search.search(search.filterByTagOrIngridient, param, "tag")

  searchByIngridient: (param) ->
    search = new RecipeMe.SearchController(param, "ingridient")
    search.search(search.filterByTagOrIngridient, param, "ingridient")

  newsList: ->
    new RecipeMe.NewsController().index()

  newNews: ->
    new RecipeMe.NewsController().new()

  editNews: (id) ->
    new RecipeMe.NewsController().edit(id)

  showNews: (id) ->
    new RecipeMe.NewsController().show(id)
