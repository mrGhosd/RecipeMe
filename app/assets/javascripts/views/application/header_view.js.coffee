class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  events:
    "click .login-window": 'loginDialog'
    "click .registration-window": 'registrationDialog'
    "click .sign-out .sign-out-button": 'signOut'

  initialize: ->
    this.render()

  loginDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    login = new RecipeMe.Views.LoginView({el: ".actions-views"})

  registrationDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    registration = new RecipeMe.Views.RegistrationView({el: ".actions-views"})

  signOut: ->
    $.ajax "/users/sign_out",
      type: "DELETE"
      success: (data, textStatus, jqXHR) ->
        window.location.reload()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR.responseText



  render: ->
    $(@el).html(@template())
    this