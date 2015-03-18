class RecipeMe.Views.CallbackForm extends Backbone.View
  template: JST["callbacks/form"]

  events:
    'submit #callback-form': 'createCallback'

  initialize: (params) ->
    if params
      @callbacks = new RecipeMe.Collections.Callbacks()

    @callback = new RecipeMe.Models.Callback()


  render: ->
    $(@el).html(@template(callback: @callback))
    this

  createCallback: (event) ->
    callbacks = @collection
    event.preventDefault()
    event.stopPropagation()
    attributes = window.appHelper.formSerialization($("#callback-form"))
    @callback.save(attributes,
      success: (response, request) ->
        callbacks.add(response)
      error: (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#callback-form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#callback-form input[name=\"#{key}\"]"))
        )
    )

