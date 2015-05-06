class RecipeMe.Models.Feed extends Backbone.Model
  initialize: (params) ->
    if params.id
      @user = params.id
      @feed = params.feed

  url: ->
    if @user && @feed
      return "api/users/#{@user}/feeds/#{@feed}"
    else if @user
      return "api/users/#{@user}/feeds"

  parse: (response) ->
    if response.follower_user
      response.follower_user = new RecipeMe.Models.User(response.follower_user)
    if response.update_entity == "Recipe" && response.update_type == "create"
      recipe = new RecipeMe.Models.Recipe(response.entity)
      view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "add73.png"})
      response.body = view
    if response.update_entity == "Vote" && response.update_entity_for == "Recipe"
      recipe = new RecipeMe.Models.Recipe(response.entity)
      view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "up_filled-32.png"})
      response.body = view
    if response.update_entity == "Comment" && response.update_type == "create"
      comment = new RecipeMe.Models.Comment(response.entity)
      view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.recipe, icon: "add73.png"})
      response.body = view
    if response.update_entity == "Vote" && response.update_entity_for == "Comment"
      comment = new RecipeMe.Models.Comment(response.entity)
      view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.recipe, icon: "up_filled-32.png"})
      response.body = view
    return response
