class RecipeMe.Collections.Recipes extends Backbone.Collection
  url: '/api/recipes'
  model: RecipeMe.Models.Recipe

  pagination: (perPage, page) ->
    page = page-1;
    collection = this;
    collection = _(collection.rest(perPage*page));
    collection = _(collection.first(perPage));
    return collection.map( (model) ->
      return model.toJSON() )

