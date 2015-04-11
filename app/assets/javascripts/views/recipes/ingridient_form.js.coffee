class RecipeMe.Views.IngridientForm extends Backbone.View
  template: JST['recipes/ingridients_form']
  className: 'ingridient-item'
  events:
    'click .ingridient-name':'showIngridientsPopup'
    'keydown .ingridient-name': 'showIngridientsPopup'
    'focusout input.ingridient-name': 'updateName'
    'focusout input.ingridient-size': 'updateSize'
    'click .remove-ingridient': 'removeIngridient'

  initialize: (params) ->
    if params
      @model = params.model
      @collection = params.collection

  updateName: (event) ->
    text = $(event.currentTarget).val()
    @model.set({name: text})

  updateSize: (event) ->
    text = $(event.currentTarget).val()
    @model.set({size: text})

  removeIngridient: (event) ->
    if @model.isNew()
      @model.collection.remove(@model)
    else
      @model.url =  "api/recipes/#{@model.collection.recipe}/ingridients/#{@model.get("id")}"
      @model.destroy()
    $(event.target).closest(".ingridient-item").remove()

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