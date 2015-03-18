class RecipeMe.Views.Callback extends Backbone.View
  template: JST["callbacks/callback"]

  events:
    'click .destroy-callback': 'destroyCallback'

  initialize: (params) ->
    if params.callback
      @model = params.callback


  destroyCallback: (event) ->
    event.preventDefault()
    callbacks = @model.collection
    @model.destroy
      success: (request, response) ->
        callbacks.remove(@model)


  render: ->
    $(@el).html(@template(callback: @model))
    this

