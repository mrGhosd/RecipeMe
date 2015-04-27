class RecipeMe.NewsController

  index: ->
    this.newsCollectionUpload()
    view = new RecipeMe.Views.NewsIndex({collection: @collection})
    $("section#main").html(view.el)
    view.render()

  new: ->
    if RecipeMe.currentUser
      view = new RecipeMe.Views.NewsForm()
      $("section#main").html(view.el)
      view.render()
    else
      new RecipeMe.ErrorHandler().forbidden()

  edit: (id) ->
    news = new RecipeMe.Models.New({id: id})
    news.fetch
      success: (model) ->
        if RecipeMe.currentUser
          view = new RecipeMe.Views.NewsForm({model: model})
          $("section#main").html(view.el)
          view.render()
        else
          new RecipeMe.ErrorHandler().forbidden()

  show: (id) ->
    news = new RecipeMe.Models.New({id: id})
    news.fetch
      success: (model) ->
        view = new RecipeMe.Views.NewsShow({model: model})
        $("section#main").html(view.el)
        view.render()

  newsCollectionUpload: ->
    @collection = new RecipeMe.Collections.News()
    @collection.fetch({async: false})