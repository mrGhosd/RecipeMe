class RecipeMe.Views.CallbackForm extends Backbone.View
  template: JST["callbacks/form"]

  events:
    'submit #callback-form': 'createCallback'

  initialize: (params) ->
    if params
      @callbacks = params.collection
    else
      @callback = new RecipeMe.Models.Callback()


  render: ->
    $(@el).html(@template(callback: @callback))
    this

  createCallback: (event) ->
    event.preventDefault()
    event.stopPropagation()
    attributes = window.appHelper.formSerialization($("#callback-form"))
    @collection.add(attributes)