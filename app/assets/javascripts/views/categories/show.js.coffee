class RecipeMe.Views.CategoryShow extends Backbone.View
  template: JST["categories/show"]
  className: "category-view"

  initialize: (params = {})->
    @page = 1
    if params.model
      @model = params.model
      @recipes = @model.get("recipes")
    this.render()

  successCategoriesRecipeUpload: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $(".category-view ul.recipes_list").append(view.render().el)


  render: ->
    $(@el).html(@template(category: @model))
    @recipes.each(@renderRecipe)
    window.scrollUpload.init(@page, "api/categories/#{@model.get('id')}/recipes", $(".category-view ul.recipes_list"), this.successCategoriesRecipeUpload)
    this

  renderRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").prepend(view.render().el)