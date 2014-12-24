class RecipeMe.Views.LoginView extends Backbone.View

  template: JST['shared/login']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this