class RecipeMe.Views.CategoryShow extends Backbone.View
  template: JST["categories/show"]
  className: "category-view"

  initialize: (params = {})->
    @page = 1
    @listenTo(Backbone, "Category", @updateCategory)

    if params.model
      @model = params.model
      @recipes = @model.get("recipes")
      @recipes.on('add', @render, this)
      @recipes.on('change', @render, this)
      @recipes.on('remove', @render, this)
      @recipes.on('reset', @render, this)
      @listenTo(Backbone, "Recipe", @updateRecipe)
    this.render()

  updateRecipe: (data) ->
    if parseInt(data.obj.category_id, 10) == parseInt(@model.get("id"), 10)
      @recipe = @recipes.get(data.id)
      if data.action == "create"
        @recipe = new RecipeMe.Models.Recipe(data.obj)
        @recipes.add(@recipe)
      if data.action == "attributes-change"
        @recipe.set(data.obj)
      if data.action == "image"
        @recipe.set({image: data.image})
      if data.action == "destroy"
        @recipes.remove(@recipe)

  addRecipe: (recipe) ->
    console.log recipe
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").prepend(view.render().el)

  updateCategory: (data) ->
    if data.id == @model.get("id")
      if data.action == "update"
        @model = new RecipeMe.Models.Category(data.obj)
        @model.set(data.obj)
        this.render()
      if data.action == "image"
        @model.set({image: data.image})
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