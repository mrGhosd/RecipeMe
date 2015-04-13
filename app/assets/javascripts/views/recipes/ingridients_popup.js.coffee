class RecipeMe.Views.IngridientPopup extends Backbone.View
  template: JST['recipes/ingridients_popup']
  className: 'ingridient-popup'
  events:
    'click .ingridient-value': 'ingidientElementChose'

  initialize: (params) ->
    if params.model
      @ingridient = params.model

  ingidientElementChose: (event) ->
    event.preventDefault()
    event.stopPropagation()
    value  = $(event.target).text()
    $(event.target).closest(".ingridient-popup").prev(".ingridient-name").val(value)
    @ingridient.set({name: value})
    $(".ingridient-popup").remove()

  hideIngridientsPopup: (event) ->
    $(".ingridient-popup").remove()

  render: (params) ->
    $(@el).html(@template(collection: params.list))
    this
