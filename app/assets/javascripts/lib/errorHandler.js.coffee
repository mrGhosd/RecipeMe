class RecipeMe.ErrorHandler
  constructor: (response, request) ->
    if request
      @status = request.status
      @message = request.responseJSON

  showFormErrorMessage: (form) ->
    if @status == 401 || @status == 403
      this.formMessageForbidden(form)
    if @status == 422
      this.formMessageError(form)

  showErrorPage: ->
    if @status == 404
      this.status404()
    if @status == 422
      this.forbidden()


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
    view = new RecipeMe.Views.NotFound()
    $("section#main").html(view.render().el)

  forbidden: ->
    view = new RecipeMe.Views.Forbidden()
    $("section#main").html(view.render().el)
