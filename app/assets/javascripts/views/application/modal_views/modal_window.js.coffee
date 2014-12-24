class RecipeMe.Views.ModalWindow extends Backbone.View
  template: JST['application/modal_window']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this