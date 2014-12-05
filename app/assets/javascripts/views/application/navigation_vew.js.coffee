class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this



