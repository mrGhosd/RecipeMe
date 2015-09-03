class RecipeMe.Views.ModalWindow extends Backbone.View
  template: JST['application/modal_window']
  events:
    "click .modal-body .nav.nav-tabs>li": "changeModalView"
    "click .send-data": "sendFormData"
    'click a.oauth-link': 'omniauthLogin'


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

  omniauthLogin: (event) ->
    event.preventDefault()
    event.stopPropagation()
    link = $(event.target).parent()
    if link.attr("require-email") != undefined
      modal = new RecipeMe.Views.CommonModal()
      emailView = new RecipeMe.Views.AdditionalEmail({url: "#{link.attr('href')}"})
      $("#myModal").html($(modal.render().el).modal('show'))
      $("#common-modal").removeClass("modal-lg")
      $("#common-modal .modal-title").html("#{I18n.t('application.additional_email.title')}")
      $("#common-modal .modal-body").html(emailView.render().el)
      $("#common-modal").modal('show')
    else
      window.location.href = link.attr("href")

  sendFormData: ->
    form = $("#authModal .actions-views").find("form")
    $("#authModal input").removeClass("error")
    $("#authModal .error-text").remove()
    user = new RecipeMe.Models.User()
    if form.attr("action") == "/users/sign_in"
      url = "/users/sign_in"
    else if form.attr("action") == "/users"
      url = "/users"
    else
      url = "/api/users/generate_new_password_email"
    user.url = url
    console.log url
    attributes = {"user": window.appHelper.formSerialization(form)}
    user.save(attributes,
      success: ->
        if url != "/api/users/generate_new_password_email"
          RecipeMe.currentUser = user
          Backbone.trigger("Auth", user)
          Backbone.history.stop()
          Backbone.history.start()
          $("#myModal").modal('hide')
        else
          modal = new RecipeMe.Views.CommonModal()
          $("#myModal").html($(modal.render().el).modal('show'))
          $("#common-modal").removeClass("modal-lg")
          $("#common-modal .modal-title").html("#{I18n.t('application.recovery.title')}")
          $("#common-modal .modal-body").html("<p>#{I18n.t('application.recovery.text')}</p>")
          $("#common-modal").modal('show')
      error: (response, request) ->
        if request.responseText != "" && url != "/api/users/generate_new_password_email"
          object = JSON.parse(request.responseText)
          if form.attr("action") == "/users/sign_in"
            $("#authModal form input").addClass("error")
            $("#authModal form #user_password").parent().append("<div class='error-text'>#{object.error}</div>")

          $.each(object.errors, (key, value)->
            $("#authModal #user_"+key).addClass("error")
            $.each(value, (element) ->
              $("#authModal #user_"+key).parent().append("<div class='error-text'>#{value[element]}</div>")
            )
          )
    )


  render: ->
    $(@el).html(@template())
    this