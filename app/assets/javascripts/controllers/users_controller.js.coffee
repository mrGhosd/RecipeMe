class RecipeMe.UsersController
  constructor: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch()

  show:(id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        user_recipes = new RecipeMe.Collections.Recipes(user.get('recipes'))
        user_recipes.fetch({reset: true})
        profile = new RecipeMe.Views.UserProfile({user: user, recipes: user_recipes})
        $("section#main").html(profile.el)
        profile.render()