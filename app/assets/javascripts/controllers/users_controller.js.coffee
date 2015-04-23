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
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

  followers: (id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        followers = new RecipeMe.Collections.Users({usersURL: "api/users/#{model.get("id")}/followers"})
        followers.fetch
          success: (collection) ->
            view = new RecipeMe.Views.UsersList({collection: collection, user: user})
            $("section#main").html(view.el)
            view.render()
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

  following: (id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        followers = new RecipeMe.Collections.Users({usersURL: "api/users/#{user.get("id")}/following"})
        followers.fetch
          success: (collection) ->
            view = new RecipeMe.Views.UsersList({collection: collection, user: user})
            $("section#main").html(view.el)
            view.render()
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

  userFeed: (id) ->
    model = new RecipeMe.Models.User({id: id})
    model.fetch
      success: (user) ->
        feed = new RecipeMe.Collections.Feeds({user: user.id})
        feed.fetch
          success: (collection, request) ->
            if RecipeMe.currentUser && RecipeMe.currentUser.get("id") == user.get("id")
              view = new RecipeMe.Views.FeedList({collection: collection})
              $("section#main").html(view.el)
              view.render()
            else
              new RecipeMe.ErrorHandler(collection, request).forbidden()
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

