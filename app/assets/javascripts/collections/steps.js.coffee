class RecipeMe.Collections.Steps extends Backbone.Collection
  model: RecipeMe.Models.Step

  initialize: (options)->
    @recipe = options.recipe if options

  url: (option) ->
    if @recipe
      return "api/recipes/#{@recipe}/steps"