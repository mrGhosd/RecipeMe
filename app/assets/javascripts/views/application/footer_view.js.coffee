class RecipeMe.Views.FooterView extends Backbone.View

  template: JST['application/footer']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this