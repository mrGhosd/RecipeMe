class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  events:
    'click .destroy-recipe': 'destroyRecipe'
    'scroll window': 'checkScroll'

  initialize: (param)->
    @page = 1
    @collection = param.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  successRecipesUpload: (response, request) ->
    for model in response
      recipe = new RecipeMe.Models.Recipe(model)
      view = new RecipeMe.Views.Recipe(model: recipe)
      $("ul.recipes_list").append(view.render().el)

  addRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").append(view.render().el)

  destroyRecipe: (event)->
    model = @collection.get(id: $(event.target).data("recipeId"))
    model.destroy
      success: ->
        $(event.target).closest("li").fadeOut('slow')


  render: ->
    $(@el).html(@template())
    @collection.each(@addRecipe)
    window.scrollUpload.init(@page, 'api/recipes', $("ul.recipes_list"), this.successRecipesUpload)
    this




