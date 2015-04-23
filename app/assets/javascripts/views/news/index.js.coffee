class RecipeMe.Views.NewsIndex extends Backbone.View
  template: JST["news/index"]
  className: "news-main"

  initialize: (params) ->
    @page = 1
    @collection = params.collection
    @collection.on('remove', @render, this)
    @collection.on('change', @render, this)
    @collection.on('add', @render, this)
    @collection.bind('add', @render, this)
    @listenTo(Backbone, "News", @updateNews)

  updateNews: (data) ->
    @model = @collection.get(data.id)
    if data.action == "create"
      @model = new RecipeMe.Models.New(data.obj)
      @collection.add(@model)
    if data.action == "destroy"
      @collection.remove(@model)
    if data.action == "update"
      @model.set(data.obj)
    if data.action == "rate"
      @model.set({rate: data.obj.rate})
    if data.action == "update"
      @model.set(data.obj)
    if data.action == "image"
      @model.set({image: data.image})

  addNews: (model) ->
    view = new RecipeMe.Views.News({model: model})
    $(".news-list").append(view.render().el)

  successNewsUpload: (response, request, collection) ->
    for model in response
      collection.push(model)

  render: ->
    $(@el).html(@template())
    @collection.each(@addNews)
    window.scrollUpload.init(@page, "api/news", $(".news-main .news-list"), this.successNewsUpload, @collection)
    this