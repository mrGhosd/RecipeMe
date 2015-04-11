class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']

  events:
    'click .destroy-recipe': 'destroyRecipe'
    'scroll window': 'checkScroll'

  initialize: (param)->
    @klass = this
    @page = 1
    @collection = param.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    this.on('scroll', this.checkScroll)
    $(window).on('scroll', this.checkScroll)

  checkScroll: (event) ->
    if $(document).height() <= $(window).scrollTop() + $(window).height()
      if $(".upload-image").length == 0
        gif = $("<img src='/images/ajax-loader.gif' class='upload-image'/>")
        $(".main-content").after(gif)

  addRecipe: (recipe) ->
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.recipes_list").append(view.render().el)

  destroyRecipe: (event)->
    model = @collection.get(id: $(event.target).data("recipeId"))
    model.destroy
      success: ->
        $(event.target).closest("li").fadeOut('slow')

  uploadRecipes: (event) ->
    gif = $("<img src='/images/ajax-loader.gif' class='upload-image'/>")
    $(".main-content").after(gif)


  render: ->
    $(@el).html(@template())
    @collection.each(@addRecipe)
    this




