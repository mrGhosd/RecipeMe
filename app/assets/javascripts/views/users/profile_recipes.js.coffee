class RecipeMe.Views.ProfileRecipes extends Backbone.View

  template: JST['users/profile_recipes']

  events:
    'click .destroy-recipe': 'destroyRecipe'

  initialize: (param)->
    @collection =  param.collection
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@addRecipe)
    this

  addRecipe: (recipe) ->
    view = new RecipeMe.Views.ProfileRecipe({model: recipe})
    $(".user-recipes-body .user-recipes-list").append(view.el)
    view.render()
