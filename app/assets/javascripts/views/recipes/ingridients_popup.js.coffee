class RecipeMe.Views.IngridientPopup extends Backbone.View
  template: JST['recipes/ingridients_popup']
  className: 'ingridient-popup'
  events:
    'click .ingridient-value': 'ingidientElementChose'

  initialize: ->

  ingidientElementChose: (event) ->
    value  = $(event.target).text()
    console.log $(event.target).closest(".ingridient-popup").prev(".ingridient-name")
    $(event.target).closest(".ingridient-popup").prev(".ingridient-name").val(value)
    $(".ingridient-popup").remove()

  render: (params) ->
    $(@el).html(@template(collection: params.list))
    this
