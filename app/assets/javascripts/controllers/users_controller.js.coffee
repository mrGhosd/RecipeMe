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

  followers: (id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        followers = new RecipeMe.Collections.Users({usersURL: "api/users/#{model.get("id")}/followers"})
        followers.fetch ->

  following: (id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        console.log user
        followers = new RecipeMe.Collections.Users({usersURL: "api/users/#{user.get("id")}/following"})
        followers.fetch
          success: (collection) ->
            console.log collection
            view = new RecipeMe.Views.UsersList({collection: collection})
            $("section#main").html(view.el)
            view.render()

