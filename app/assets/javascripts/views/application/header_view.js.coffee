class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  events:
    "click .login-window": 'modalDialog'

  initialize: ->
    this.render()

  modalDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})


  render: ->
    $(@el).html(@template())
    this