class RecipeMe.Views.ModalWindow extends Backbone.View
  template: JST['application/modal_window']
  events:
    "click .modal-body .nav.nav-tabs>li": "changeModalView"
    "click .send-data": "sendFormData"

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
    else if chosenView == "recovery"
      view = new RecipeMe.Views.PasswordRecoveryView({el: ".actions-views"})

  sendFormData: ->
    form = $("#authModal .actions-views").find("form")
    url = $(form).attr("action")
    console.log $(form).serialize()
#    $.ajax url,
#      type: "POST"
#      data: $(form).serialize()
#      dataType: "json"
#      success: (data, textStatus, jqXHR)->
#        window.location.reload()
#      error: (jqXHR, textStatus, errorThrown) ->
#        object = JSON.parse(jqXHR.responseText)
#        if url == "/users/sign_in"
#          $("#myModal form input").addClass("error")
#          $("#myModal form #user_password").parent().append("<div class='error-text'>#{object.error}</div>")
#
#        $.each(object.errors, (key, value)->
#          $("#myModal #user_"+key).addClass("error")
#          $.each(value, (element) ->
#            $("#myModal #user_"+key).parent().append("<div class='error-text'>#{value[element]}</div>")
#          )
#        )


  render: ->
    $(@el).html(@template())
    this