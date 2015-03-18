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

  edit: (id) ->
    news = new RecipeMe.Models.New({id: id})
    news.fetch
      success: (model) ->
        view = new RecipeMe.Views.NewsForm({model: model})
        $("section#main").html(view.el)
        view.render()