class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  events:
    'click .destroy-recipe': 'destroyRecipe'
    'scroll window': 'checkScroll'
    'click .recipe-filter': 'filterRecipes'

  initialize: (param)->
    @page = 1
    @filter_attr = "rate"
    @filter_ord = "desc"
    @filter_count = null
    @collection = param.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  successRecipesUpload: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $("ul.recipes_list").append(view.render().el)

  filterRecipes: (event) ->
    @filter_attr = $(event.target).attr("filter")
    @filter_ord = $(event.target).attr("order")
    @filter_count = $(event.target).attr("count")
    if $(event.target).attr("order") == "desc"
      ord_value = "asc"
    else
      ord_value = "desc"
    $(event.target).attr("order", ord_value)
    console.log @filter_attr + " " + @filter_ord + " " + @filter_count

  addRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").append(view.render().el)

  loadRecipesCollection: ->
    recipes = @collection
    $.ajax "api/recipes",
      type: "GET"
      data: {filter_attr: @filter_attr, filter_order: @filter_ord, filter_count: @filter_count}
      success: (response, request) ->
        recipes = new RecipeMe.Collections.Recipes(response)
        recipes.each(@addRecipe)

  destroyRecipe: (event)->
    model = @collection.get(id: $(event.target).data("recipeId"))
    model.destroy
      success: ->
        $(event.target).closest("li").fadeOut('slow')


  render: ->
    $(@el).html(@template())
    @collection.each(@addRecipe)
    window.scrollUpload.init(@page, "api/recipes?filter_attr=#{@filter_attr}&filter_order=#{@filter_ord}", $("ul.recipes_list"), this.successRecipesUpload)
    this




