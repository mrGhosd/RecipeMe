class RecipeMe.Collections.Steps extends Backbone.Collection
  model: RecipeMe.Models.Step

  initialize: (options)->
    @recipe = options.recipe if options != null

  url: (option) ->
    return "api/recipes/#{@recipe}/comments" if option != null