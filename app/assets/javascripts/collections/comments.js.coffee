class RecipeMe.Collections.Comments extends Backbone.Collection
  model: RecipeMe.Models.Comment

  initialize: (options)->
    if options
      @recipe = options.recipe
      @path = options.url

  url: ->
    if @path
      return @path
    if @recipe
      return "api/recipes/#{@recipe}/comments"
