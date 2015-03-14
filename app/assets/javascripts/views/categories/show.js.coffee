class RecipeMe.Views.CategoryShow extends Backbone.View
  template: JST["categories/show"]
  className: "category-view"

  initialize: (params = {})->
    if params.model
      @model = params.model
      @recipes = @model.get("recipes")
    this.render()

  render: ->
    $(@el).html(@template(category: @model))
    @recipes.each(@renderRecipe)
    this

  renderRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    console.log view
    $("ul.recipes_list").prepend(view.render().el)