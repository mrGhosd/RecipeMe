class RecipeMe.Models.Feed extends Backbone.Model
  initialize: (params) ->
    if params && params.id
      @user = params.id
      @feed = params.feed
    else
      @user = undefined
      @feed = undefined

  url: ->
    if @user && @feed
      return "api/users/#{@user}/feeds/#{@feed}"
    else if @user
      return "api/users/#{@user}/feeds"
    else
      return "api/users"

  parse: (response) ->
    if response.user
      response.follower_user = new RecipeMe.Models.User(response.user)
    if response.entity == "Recipe" && response.event_type == "create"
      recipe = new RecipeMe.Models.Recipe(response.object)
      view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "add73.png"})
      response.body = view
    if response.entity == "Comment" && response.event_type == "create"
      comment = new RecipeMe.Models.Comment(response.object)
      view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.parent_object, icon: "add73.png"})
      response.body = view
    if response.entity == "Vote" && response.event_type == "create"
      if response.parent_object
        recipe = new RecipeMe.Models.Recipe(response.parent_object)
        view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "up_filled-32.png"})
        response.body = view
      else
        comment = new RecipeMe.Models.Comment(response.parent_object)
        view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.object, icon: "up_filled-32.png"})
        response.body = view
#    if response.entity == "Vote" && response.update_entity_for == "Recipe"

    return response
