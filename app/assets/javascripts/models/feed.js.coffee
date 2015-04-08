class RecipeMe.Models.Feed extends Backbone.Model
  initialize: (params) ->
    if params.id
      @user = params.id

  url: ->
    if @user
      return "api/users/#{@user}/feeds"

  parse: (response) ->
    if response.update_entity == "Recipe" && response.update_type == "create"
      recipe = new RecipeMe.Models.Recipe({id: response.update_id})
      recipe.fetch({async: false})
      view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "add73.png"})
      response.body = view
    if response.update_entity == "Vote" && response.update_entity_for == "Recipe"
      recipe = new RecipeMe.Models.Recipe({id: response.update_id})
      recipe.fetch({async: false})
      view = new RecipeMe.Views.FeedRecipe({model: recipe, icon: "up_filled-32.png"})
      response.body = view
    if response.update_entity == "Comment" && response.update_type == "create"
      comment = new RecipeMe.Models.Comment({recipe: response.recipe.id, id: response.update_id})
      comment.fetch({async: false})
      view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.recipe, icon: "add73.png"})
      response.body = view
    if response.update_entity == "Vote" && response.update_entity_for == "Comment"
      console.log response
      comment = new RecipeMe.Models.Comment({recipe: response.recipe.id, id: response.update_id})
      comment.fetch({async: false})
      view = new RecipeMe.Views.FeedComment({model: comment, recipe: response.recipe, icon: "up_filled-32.png"})
      response.body = view
    return response
