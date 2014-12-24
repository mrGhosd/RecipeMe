class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  events:
    "click .login-window": 'loginDialog'

  initialize: ->
    this.render()

  loginDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    login = new RecipeMe.Views.LoginView({el: ".actions-views"})


  render: ->
    $(@el).html(@template())
    this