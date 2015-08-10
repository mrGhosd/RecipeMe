class RecipeMe.Models.Ingridient extends Backbone.Model

  initialize: (params) ->
    if params && params.recipe
      @recipe = params.recipe
    else
      @recipe = undefined

  url: ->
    if @recipe
      return "api/recipes/#{@recipe}/ingridients"
    else
      return "api/ingridients"

  toJSON: (params) ->
    if this.attributes["in_size"]
      this.attributes["size"] = this.attributes["in_size"]
      delete this.attributes["in_size"]
    this.attributes["ingridient_attributes"] = { name: this.get("name") }
    super

