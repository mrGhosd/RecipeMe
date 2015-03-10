class RecipeMe.Models.Step extends Backbone.Model

  initialize: (options) ->
    @recipe = options.id if options.id

    url: ->
      return "api/recipes/#{@recipe.id}/steps" if @recipe.id