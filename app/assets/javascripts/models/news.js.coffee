class RecipeMe.Models.New extends Backbone.Model
  urlRoot: '/api/news'

  initialize: (params) ->
    if params == undefined
      this.set("image", new RecipeMe.Models.Image())
