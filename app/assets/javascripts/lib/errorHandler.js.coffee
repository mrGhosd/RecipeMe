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
        for step_element in value
          for k, v of step_element
            for attr_name, attr_error of v
              if attr_name == "description"
                $(steps_form[k]).find("textarea[name=\"#{attr_name}\"]").addClass("error")
                $("<div class='error-text'>#{attr_error[0]}</div>").insertAfter($(steps_form[k]).find("textarea[name=\"#{attr_name}\"]"))
              if attr_name == "image"
                $(steps_form[k]).find(".step-placeholder.empty").addClass("error")
                $("<div class='error-text'>#{attr_error[0]}</div>").insertAfter($(steps_form[k]).find(".step-placeholder.empty"))

      if key == "ingridients"
        ingridient_form = form.find(".ingridients-list").find(".ingridient-item")
        for ingridient_element in value
          continue if typeof ingridient_element == "string"
          for k, v of ingridient_element
            for attr_name, attr_error of v
              if attr_name == "name"
                $(ingridient_form[k]).find("input[name=\"ingridient-#{attr_name}\"]").addClass("error")
                $("<div class='error-text'>#{attr_error[0][attr_name][0]}</div>").insertAfter($(ingridient_form[k]).find("input[name=\"ingridient-#{attr_name}\"]"))
              if attr_name == "size"
                $(ingridient_form[k]).find("input[name=\"#{attr_name}\"]").addClass("error")
                $("<div class='error-text'>#{attr_error[0]}</div>").insertAfter($(ingridient_form[k]).find("input[name=\"#{attr_name}\"]"))

    )

  status404: ->
    view = new RecipeMe.Views.NotFound()
    $("section#main").html(view.render().el)

  forbidden: ->
    view = new RecipeMe.Views.Forbidden()
    $("section#main").html(view.render().el)
