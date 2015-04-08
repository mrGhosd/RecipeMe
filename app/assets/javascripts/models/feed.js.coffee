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
    return response
