class RecipeMe.Views.Callback extends Backbone.View
  template: JST["callbacks/callback"]

  initialize: (params) ->
    if params.callback
      @model = params.callback


  render: ->
    $(@el).html(@template(callback: @model))
    this

