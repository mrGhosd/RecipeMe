class RecipeMe.Models.Category extends Backbone.Model
  urlRoot: 'api/categories'

  initialize: (params) ->
    if params
      @category_id = params.id
    else
      this.set("image", new RecipeMe.Models.Image())

  parse: (response) ->
    if response.recipes
      response.recipes = new RecipeMe.Collections.Recipes({category_id: response.id})
      response.recipes.fetch({async: false})
    return response