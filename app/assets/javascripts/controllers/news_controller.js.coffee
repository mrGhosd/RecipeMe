class RecipeMe.NewsController
  constructor: ->
    @collection = new RecipeMe.Collections.News()
    @collection.fetch({async: false})

  index: ->
    view = new RecipeMe.Views.NewsIndex({collection: @collection})
    $("section#main").html(view.el)
    view.render()

  new: ->
    view = new RecipeMe.Views.NewsForm()
    $("section#main").html(view.el)
    view.render()