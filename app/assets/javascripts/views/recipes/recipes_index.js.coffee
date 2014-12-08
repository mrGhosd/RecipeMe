class RecipeMe.Views.RecipesIndex extends Backbone.View

  template: JST['recipes/index']
  events:
    'click .show_form': 'show_form'

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template(recipes: @collection))
    this

  show_form: ->
    view = new RecipeMe.Views.RecipesForm(collection: @collection)
    $(".recipes_form_hold").html(view.el)
    view.render()
