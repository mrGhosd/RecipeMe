class RecipeMe.Views.CommonModal extends Backbone.View
  template: JST['application/common_modal']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this