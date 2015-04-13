class RecipeMe.ErrorHandler
  constructor: (response, request) ->
    @status = request.status
    @message = request.responseJSON

  formMessageForbidden: (form) ->
    form.after("<div class='error-text'>#{ I18n.t('errors.forbidden')}</div>")

  formMessageError: (form) ->
    $.each(@message, (key, value)->
      form.find("input[name=\"#{key}\"]").addClass("error")
      form.find("textarea[name=\"#{key}\"]").addClass("error")
      if key == "description"
        $("<div class='error-text'>#{value[0]}</div>").insertAfter(form.find("textarea[name=\"#{key}\"]"))
      else
        $("<div class='error-text'>#{value[0]}</div>").insertAfter(form.find("input[name=\"#{key}\"]"))
    )

  status404: ->

