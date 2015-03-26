class RecipeMe.Views.Ingridient extends Backbone.View
  template: JST['recipes/ingridient']
  className: 'ingridient-block'

  initialize: (params) ->
    @model = params.model if params.model

  render: ->
    $(@el).html(@template(ingridient: @model))
    this