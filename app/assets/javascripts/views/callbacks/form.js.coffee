class RecipeMe.Views.CallbackForm extends Backbone.View
  template: JST["callbacks/form"]

  events:
    'submit #callback-form': 'createCallback'
    'click .remove-form': 'removeForm'

  initialize: (params) ->
    if params.model
      @callback = params.model
    else
      @callback = new RecipeMe.Models.Callback()


  render: ->
    $(@el).html(@template(callback: @callback))
    this

  createCallback: (event) ->
    console.log @collection
    callbacks = @collection
    event.preventDefault()
    event.stopPropagation()
    attributes = window.appHelper.formSerialization($("#callback-form"))
    @callback.save(attributes,
      success: (response, request) ->
        if callbacks
          callbacks.add(response)
        else
          view = new RecipeMe.Views.Callback({model: response})
          $(".callbacks-list").prepend(view.render().el)
          $("#callback-form").remove()
      error: (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#callback-form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#callback-form input[name=\"#{key}\"]"))
        )
    )

  removeForm: (event) ->
    event.preventDefault()
    $(".callback-item").show()
    $(event.target).closest("#callback-form").remove()

