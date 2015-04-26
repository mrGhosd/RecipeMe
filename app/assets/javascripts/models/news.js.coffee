class RecipeMe.Models.New extends Backbone.Model
  urlRoot: '/api/news'

  initialize: (params) ->
    if params.length == 0
      this.set("image", new RecipeMe.Models.Image())