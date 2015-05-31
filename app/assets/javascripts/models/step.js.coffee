class RecipeMe.Models.Step extends Backbone.Model
  fileAttribute: 'image'

  initialize: (options) ->
    if options
      @step_id = options.id
      @recipe_id = options.recipe_id
    else
      this.set("image", new RecipeMe.Models.Image())

  url: ->
    if @step_id
      return "/api/recipes/#{@recipe_id}/steps/#{@step_id}"
    else
      return "/api/recipes/#{@recipe_id}/steps"
