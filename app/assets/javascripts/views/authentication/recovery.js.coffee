class RecipeMe.Views.PasswordRecoveryView extends Backbone.View

  template: JST['shared/recovery_password']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this