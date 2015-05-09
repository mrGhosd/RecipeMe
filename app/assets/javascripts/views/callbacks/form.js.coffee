class RecipeMe.Views.CallbackForm extends Backbone.View
  template: JST["callbacks/form"]

  events:
    'submit #callback-form': 'createCallback'
    'click .remove-form': 'removeForm'

  initialize: (params) ->
    if params.model
      @callback = params.model
      @collection = params.collection
    else
      @callback = new RecipeMe.Models.Callback()


  render: ->
    $(@el).html(@template(callback: @callback))
    this

  createCallback: (event) ->
    event.preventDefault()
    event.stopPropagation()
    $(".error-text").remove()
    callbacks = @collection
    attributes = window.appHelper.formSerialization($("#callback-form"))
    @callback.save attributes, {
      wait: true,
      success: (response, request) ->
        console.log response
        console.log request
      error: (response, request) ->
        error = new RecipeMe.ErrorHandler(response, request)
        error.showFormErrorMessage($("#callback-form"))
        }


  removeForm: (event) ->
    event.preventDefault()
    $(".callback-item").show()
    $(event.target).closest("#callback-form").remove()

