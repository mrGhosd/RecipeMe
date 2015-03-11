class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'click .recipe-image': 'resetFile'
    'change .recipe-image': 'fileUploadAccept'
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'
    'click #recipePlaceholder': 'triggerFileUpload'
    'dragenter #recipePlaceholder': 'enterDrag'
    'dragleave #recipePlaceholder': 'leaveDrag'
    'drop #recipePlaceholder': 'dropImage'
    'click .add-step': 'addRecipeStep'
    'click .remove-step': 'removeStep'

  initialize: (options = {}) ->
    @form = this
    if options.model
      @model = options.model
      @steps = @model.get('steps')
      @steps.fetch({async: false})
    else
      @model = new RecipeMe.Models.Recipe()
      @steps = new RecipeMe.Collections.Steps()

    this.render()
    @reader = new FileReader()
    this.initFileReader()

  initFileReader: ->
    @reader = new FileReader()
    @reader.onload = (event) ->
      dataUri = event.target.result
      img = new Image(200, 200)
      img.class = "image-view"
      img.src = dataUri
      $(".image-placeholder").html(img)
    @reader.onerror = (event) ->
      console.log "ОШИБКА!"

  createRecipe:(event) ->
    event.preventDefault()
    $("#recipe_form input, #recipe_form textarea").removeClass("error")
    $(".error-text").remove()
    attributes = window.appHelper.formSerialization($("#recipe_form"))
    console.log attributes
    this.createMainObject(attributes, this.createSteps)


  createMainObject: (attributes, callback) ->
    step = {steps: @steps, callback: this.createSteps}
    @model.createFromForm(attributes, step,
      success = (response, request) ->
        RecipeMe.currentUser.fetch()
        Backbone.history.navigate('/recipes', {trigger: true, repalce: true})
      error = (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#recipe_form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#recipe_form input[name=\"#{key}\"]"))
        )
      )


  createSteps: (steps, response, request) ->
    @steps = steps
    console.log @steps
    @steps.each (step) ->
      step.set({recipe_id: response.id})
      console.log step.get("id")
      if step.get("id") == null
        step.url = "/api/recipes/#{response.id}/steps"
      else
        step.url = "/api/recipes/#{response.id}/steps/#{step.get("id")}"
      step.save(
        success: (response, request) ->
          console.log response
          console.log request
        error: (response, request) ->
          console.log response
          console.log request
      )

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true, repalce: true})

  triggerFileUpload: ->
    $("#recipe_image").click()

  enterDrag: (event) ->
    event.preventDefault()
    $("#recipePlaceholder").addClass("entered")

  leaveDrag: (event) ->
    event.preventDefault()
    $("#recipePlaceholder").removeClass("entered")

  dropImage: (event)->
    event.preventDefault()
    event.stopPropagation()
    file = this.getFileFromEvent(event)
    @reader.readAsDataURL(file)
    $("#recipePlaceholder").removeClass("empty entered")
    this.createRecipeImage(event, "Recipe")
    console.log @model
    return false

  addRecipeStep: (event) ->
    event.preventDefault()
    if @model
      @step = new RecipeMe.Models.Step(recipe_id: @model.id)
    else
      @step = new RecipeMe.Models.Step()
    @steps.add(@step)
    this.renderRecipeStep(@step)

  renderRecipeStep: (step) ->
    view = new RecipeMe.Views.StepForm(model: step)
    $(".steps-list").append(view.render().el)

  removeStep: (event)->
    @steps.remove(@step)
    $(event.target).closest(".step-block").remove()
    console.log @steps

  render: ->
    if @model
      $(@el).html(@template(recipe: @model))
    else
      $(@el).html(@template())

    @steps.each(@renderRecipeStep)
    this
    $(".markItUp").markItUp(window.myHtmlSettings)

  fileUploadAccept: (event) ->
    $("#recipe_form .recipe-image").val()
    if $("#recipe_form .recipe-image").val() == "" || typeof $("#recipe_form .recipe-image").val() == "undefined"
      return false
    else
      $(".image-placeholder .image-view").remove()
      image = $("#recipe_form .recipe-image")[0].files[0]
      @reader.readAsDataURL(image)
      $(".image-placeholder").removeClass("empty")
      this.createRecipeImage(event, "Recipe")

  updateRecipesCollection: ->
    RecipeMe.recipesCollection.fetch()


  getFileFromEvent: (event) ->
    original = event.originalEvent
    if original.dataTransfer
      uploadedFile = original.dataTransfer.files[0]
    else
      uploadedFile = $(event.target)[0].files[0]
    return uploadedFile

  createRecipeImage: (event, type) ->
    formData = new FormData()
    file = this.getFileFromEvent(event)
    formData.append('name', file)
    formData.append('imageable_type', type)
    if $(".image-placeholder img").attr("image_id") && $(".image-placeholder img").attr("image_id").length > 0
      image_id = $(".image-placeholder img").attr("image_id")
      formData.append('imageable_id', image_id)

    request = new XMLHttpRequest();
    request.open("POST", "/api/images");
    request.send(formData);
    request.onreadystatechange = ->
      if request.readyState == 4
        response = JSON.parse(request.response)
        if response.id
          $(".hidden-image-value-recipe").val(response.id)
          $(".image-placeholder img").attr("image_id", response.id)
        else
          $(".hidden-image-value-recipe").val(response.imageable_id)
          $(".image-placeholder img").attr("image_id", response.imageable_id)

        console.log response


