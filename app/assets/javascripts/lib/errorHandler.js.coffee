class RecipeMe.ErrorHandler
  constructor: (response, request) ->
    @status = request.status
    @message = request.responseJSON

  showFormErrorMessage: (form) ->
    console.log @status
    if @status == 401 || @status == 403
      this.formMessageForbidden(form)
    if @status == 422
      this.formMessageError(form)

  showErrorPage: ->
    if @status == 404
      this.status404()
    if @status == 422 || @status == 401
      this.forbidden()


  formMessageForbidden: (form) ->
    form.after("<div class='error-text'>#{ I18n.t('errors.forbidden')}</div>")

  formMessageError: (form) ->
    $.each(@message, (key, value) ->
      form.find("input[name=\"#{key}\"]").addClass("error") if key != "image"
      form.find("textarea[name=\"#{key}\"]").addClass("error")

      if key == "file"
        return true

      if key == "description" || key == "text"
        $("<div class='error-text'>#{value[0]}</div>").insertAfter(form.find("textarea[name=\"#{key}\"]"))
      else
        $("<div class='error-text'>#{value[0]}</div>").insertAfter(form.find("input[name=\"#{key}\"]")) if key != "image"

      if key == "image"
        form.find(".image-placeholder.empty").addClass("error")
        $("<div class='error-text'>#{value[0]}</div>").insertAfter(form.find(".image-placeholder.empty"))

      if key == "steps"
        steps_form = form.find(".steps-list").find(".step-block")
        console.log steps_form
        for step_element in value
          for k, v of step_element
            console.log $(steps_form[k])
            for attr_name, attr_error of v
              if attr_name == "description"
                $(steps_form[k]).find("textarea[name=\"#{attr_name}\"]").addClass("error")
                $("<div class='error-text'>#{attr_error[0]}</div>").insertAfter($(steps_form[k]).find("textarea[name=\"#{attr_name}\"]"))
              if attr_name == "image"
                $(steps_form[k]).find(".step-placeholder.empty").addClass("error")
                $("<div class='error-text'>#{attr_error[0]}</div>").insertAfter($(steps_form[k]).find(".step-placeholder.empty"))

      if key == "ingridients"

    )

  status404: ->
    view = new RecipeMe.Views.NotFound()
    $("section#main").html(view.render().el)

  forbidden: ->
    view = new RecipeMe.Views.Forbidden()
    $("section#main").html(view.render().el)
