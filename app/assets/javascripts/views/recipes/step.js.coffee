class RecipeMe.Views.Step extends Backbone.View

  template: JST['recipes/step']
  className: "recipe-step"

  initialize: (params) ->
    @step = params.model if params.model
    this.render()

  render: ->
    $(@el).html(@template(step: @step))
    this