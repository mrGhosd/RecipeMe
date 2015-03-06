class RecipeMe.Views.RecipeStep extends Backbone.View
  template: JST['recipes/step']
  className: 'step-block'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(recipe: @model))
    this