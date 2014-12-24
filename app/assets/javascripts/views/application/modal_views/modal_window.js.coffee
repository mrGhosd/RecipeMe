class RecipeMe.Views.ModalWindow extends Backbone.View
  template: JST['application/modal_window']
  events:
    "click .modal-body .nav.nav-tabs>li": "changeModalView"

  initialize: ->
    this.render()

  changeModalView:(event) ->

    chosenView = $(event.target).data("view")
    $(".modal-body .nav.nav-tabs>li").removeClass("active")
    $(event.currentTarget).addClass("active")
    if chosenView == "login"
      view = new RecipeMe.Views.LoginView({el: ".actions-views"})
    else if chosenView == "registration"
      view = new RecipeMe.Views.RegistrationView({el: ".actions-views"})

  render: ->
    $(@el).html(@template())
    this