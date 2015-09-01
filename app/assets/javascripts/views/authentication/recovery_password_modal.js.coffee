class RecipeMe.Views.RecoveryPasswordModal extends Backbone.View
  template: JST['shared/recovery-password-modal']
  events:
    "submit .recovery-form": "recoverPassword"
  initialize:(params) ->
    this.render()

  recoverPassword: (event) ->
    event.preventDefault()
    event.stopPropagation()
    form = $(".recovery-form")
    token = Backbone.history.location.search.split("=")[1]
    attributes = {"user": window.appHelper.formSerialization(form)}
    attributes["user"]["reset_password_token"] = token
    $.ajax "/api/users/reset_password",
      type: "POST"
      data: attributes
      success: (response, request) ->
        console.log response
        console.log request
        $("#myModal").modal('hide')
        window.location.href = "/"
      error: (response, request) ->
        console.log response
        console.log request

  render: ->
    $(@el).html(@template())
    this