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
    @listenTo(Backbone, "recipe", @updateRate)
    @collection = param.collection
    @collection.on('reset', @render, this)
    @collection.on('change', @render, this)
    @collection.on('add', @render, this)

  successRecipesUpload: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $("ul.recipes_list").append(view.render().el)

  updateRate: (data) ->
    if data.action == "rate"
      model = @collection.get(data.id)
      model.set({rate: data.obj.rate})
      console.log model
      console.log data

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
    window.scrollUpload.init(@page, "api/recipes?filter_attr=#{@filter_attr}&filter_order=#{@filter_ord}", $("ul.recipes_list"), this.successRecipesUpload)
    this




