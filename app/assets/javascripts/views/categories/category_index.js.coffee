class RecipeMe.Views.CategoryIndex extends Backbone.View

  template: JST["categories/index"]

  initialize: (params) ->
    @page = 1
    if params.collection
      @collection = params.collection
      @collection.on('remove', @render, this)
      @collection.on('add', @render, this)
      @listenTo(Backbone, "Category", @updateCategory)

  updateCategory: (data) ->
    @model = @collection.get(data.id)
    if data.action == "create"
      @model = new RecipeMe.Models.Category(data.obj)
      @collection.add(@model)
    if data.action == "destroy"
      @collection.remove(@model)


  render: ->
    $(@el).html(@template)
    @collection.each(@addCategory)
    window.scrollUpload.init(@page, 'api/categories', $("div.categories-list"), this.successCategoriesUpload)
    this

  successCategoriesUpload: (response, request) ->
    for model in response
      category = new RecipeMe.Models.Category(model)
      view = new RecipeMe.Views.Category(model: category)
      $("div.categories-list").append(view.render().el)

  addCategory: (category) ->
    view = new RecipeMe.Views.Category(model: category)
    $(".categories-list").prepend(view.render().el)
