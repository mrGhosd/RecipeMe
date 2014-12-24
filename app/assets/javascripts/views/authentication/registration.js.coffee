class RecipeMe.Views.RegistrationView extends Backbone.View

  template: JST['shared/registration']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this