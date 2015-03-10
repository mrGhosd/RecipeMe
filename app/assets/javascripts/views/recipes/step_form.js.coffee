class RecipeMe.Views.StepForm extends Backbone.View
  template: JST['recipes/step_form']
  className: 'step-block'
  events:
    'change .step-image': 'uploadRecipeStepImage'

  initialize: (params)->
    @model = params.model if params.model
    this.render()

  render: ->
    if @model
      $(@el).html(@template(step: @model))
    else
      $(@el).html(@template())
    this