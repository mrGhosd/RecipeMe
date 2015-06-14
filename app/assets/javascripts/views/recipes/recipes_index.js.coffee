class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  events:
    'scroll window': 'checkScroll'
    'click .recipe-filter': 'filterRecipes'

  initialize: (param)->
    @page = 1
    @filter_attr = "rate"
    @filter_ord = "desc"
    @filter_count = null
    @listenTo(Backbone, "Recipe", @updateData)
    @collection = param.collection
    @collection.on('reset', @render, this)
    @collection.on('remove', @render, this)
    @collection.on('change', @render, this)
    @collection.on('add', @render, this)

  successRecipesUpload: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $("ul.recipes_list").append(view.render().el)

  updateData: (data) ->
    @model = @collection.get(data.id)
    if data.action == "create"
      @model = new RecipeMe.Models.Recipe(data.obj)
      @collection.add(@model)
    if data.action == "destroy"
      @collection.remove(@model)
    if data.action == "rate"
      @model.set({rate: data.obj.rate})
    if data.action == "attributes-change"
      @model.set(data.obj)
    if data.action == "image"
      @model.set({image: data.image})
    if data.action == "comment-create"
      console.log @model
      @model.set({comments_count: data.count.comments_count})
    if data.action == "comment-destroy"
      @model.set({comments_count: data.count})

  filterRecipes: (event) ->
    if($(event.target).attr("active"))

    else
      $(".recipe-filter").removeClass('btn-success btn-danger')
      $(".recipe-filter").removeAttr('active')
      $(event.target).attr("active", true)

    this.setFilterValues(event)
    console.log @filter_attr + " " + @filter_ord + " " + @filter_count
    this.loadRecipesCollection(this.showRecipesCollection)

  setFilterValues: (event) ->
    @filter_attr = $(event.target).attr("filter")
    if $(event.target).attr("order") == "desc"
      ord_value = "asc"
      $(event.target).removeClass('btn-success').addClass('btn-danger')

    else
      ord_value = "desc"
      $(event.target).removeClass('btn-danger').addClass('btn-success')
    @filter_ord = ord_value
    $(event.target).attr("order", ord_value)


  showRecipesCollection: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $("ul.recipes_list").append(view.render().el)


  addRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").append(view.render().el)

  loadRecipesCollection: (callback) ->
    $("ul.recipes_list").html("")
    recipes = @collection
    $.ajax "api/recipes",
      type: "GET"
      data: {filter_attr: @filter_attr, filter_order: @filter_ord, filter_count: @filter_count}
      success: (response, request) ->
        callback(response, request)


  render: ->
    $(@el).html(@template())
    @collection.each(@addRecipe)
#    window.scrollUpload.init(@page, "api/recipes?filter_attr=#{@filter_attr}&filter_order=#{@filter_ord}", $("ul.recipes_list"), this.successRecipesUpload, @collection)
    this




