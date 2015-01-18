class RecipeMe.Models.Comment extends Backbone.Model
  paramRoot: 'comment'

  initialize: (options)->
    @option = options
    if options != null
      @recipe = options.recipe
    else
      @recipe = 0

  url: ->
    if @option.id
      return "api/recipes/#{@recipe}/comments/#{@option.id}"
    else
      return "api/recipes/#{@recipe}/comments"

  parse: (attributes) ->
    return attributes