class RecipeMe.Views.RecipeStep extends Backbone.View
  template: JST['recipes/step']
  className: 'step-block'
  events:
    'change .step-image': 'uploadRecipeStepImage'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(step: @model))
    this