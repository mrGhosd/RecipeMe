class RecipeMe.Collections.Comments extends Backbone.Collection
  model: RecipeMe.Models.Comment

  initialize: (options)->
    if options != null
      @recipe = options.recipe
    else
      @recipe = 0

  url: (option) ->
    if option != null
      return "api/recipes/#{@recipe}/comments"
    else
      return "api/recipes/#{@recipe}/comments/#{option.url}"

  defaults:
    text: null
    user_id: null
    recipe_id: null

