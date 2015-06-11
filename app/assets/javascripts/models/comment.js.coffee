class RecipeMe.Models.Comment extends Backbone.Model
  paramRoot: 'comment'

  initialize: (options)->
    @option = options
    if options != null
      @recipe = options.recipe
    else
      @recipe = 0
    if @option && @option.user
      this.user = new RecipeMe.Models.User(@option.user)


  url: ->
    if @option.id
      return "api/recipes/#{@recipe}/comments/#{@option.id}"
    else
      return "api/recipes/#{@recipe}/comments"

  parse: (attributes) ->
    console.log attributes
    if @option && @option.user
      attributes.user = new RecipeMe.Models.User(@option.user)
    return attributes