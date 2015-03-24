class RecipeMe.Views.IngridientForm extends Backbone.View
  template: JST['recipes/ingridients_form']
  className: 'ingridient-item'
  events:
    'keydown .ingridient-name': 'showIngridientsPopup'
    'focusout .ingridient-name': 'updateName'
    'focusout .ingridient-size': 'updateSize'

  initialize: (params) ->
    if params
      @model = params.model
      @collection = params.collection

  updateName: (event) ->
    text = $(event.target).val()
    @model.set({name: text})

  updateSize: (event) ->
    text = $(event.target).val()
    @model.set({size: text})

  showIngridientsPopup: (event) ->
    $(".ingridient-popup").remove()
    current_text = $(event.target).val()
    query = @collection.search(current_text)
    if query.length > 0
      view = new RecipeMe.Views.IngridientPopup()
      $(event.target).after(view.render({list: query}).el)
    else
      $(".ingridient-popup").remove()

  render: ->
    $(@el).html(@template(ingridient: @model))
    this