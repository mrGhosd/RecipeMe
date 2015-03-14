class CategoriesController
  constructor: ->
    @categories = new RecipeMe.Collections.Categories()
    @categories.fetch({reset: true, async: false})

  


