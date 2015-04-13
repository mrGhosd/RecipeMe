class RecipeMe.ErrorHandler
  constructor: (response, request) ->
    @status = request.status
    @message = request.responseJSON

  formMessageForbidden: (form) ->
    form.after("<div class='error-text'>#{ I18n.t('errors.forbidden')}</div>")

  formMessageError: (form) ->


  status404: ->

