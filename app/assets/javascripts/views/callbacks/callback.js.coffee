class RecipeMe.Views.Callback extends Backbone.View
  template: JST["callbacks/callback"]
  className: "callback-item"

  events:
    'click .destroy-callback': 'destroyCallback'
    'click .update-callback': 'updateCallback'

  initialize: (params) ->
    if params.callback
      @model = params.callback


  destroyCallback: (event) ->
    event.preventDefault()
    callbacks = @model.collection
    @model.destroy
      success: (request, response) ->
        callbacks.remove(@model)


  updateCallback: (event) ->
    event.preventDefault()
    $("#callback-form").remove()
    form = new RecipeMe.Views.CallbackForm({model: @model})
    item = $(event.target).closest(".callback-item")
    $(item).after(form.render().el)
    $(item).hide()

  render: ->
    $(@el).html(@template(callback: @model))
    this

