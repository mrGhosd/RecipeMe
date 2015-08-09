class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'change .recipe-image': 'fileUploadAccept'
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'
    'click #recipePlaceholder': 'triggerFileUpload'
    'dragenter #recipePlaceholder': 'enterDrag'
    'dragleave #recipePlaceholder': 'leaveDrag'
    'drop #recipePlaceholder': 'dropImage'
    'click .add-step': 'addRecipeStep'
    'click .add-ingridient': 'addIngridient'

  initialize: (options = {}) ->
    window.removeEventListener("scroll")
    @form = this
    if options.model
      @model = options.model
      @steps = @model.get('steps')
      @current_ingridients = @model.get('ingridients')
    else
      @model = new RecipeMe.Models.Recipe()
      @steps = new RecipeMe.Collections.Steps()
      @current_ingridients = new RecipeMe.Collections.Ingridients()

    @common_ingridients = new RecipeMe.Collections.Ingridients()
    @common_ingridients.fetch({async: false})

    this.loadCategories()
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

  loadCategories: ->
    @categories = new RecipeMe.Collections.Categories()
    @categories.fetch({async: false})

  createRecipe:(event) ->
    event.preventDefault()
    event.stopPropagation()
    $("#recipe_form input, #recipe_form textarea").removeClass("error")
    $(".error-text").remove()
    attributes = window.appHelper.formSerialization($("#recipe_form"))
    attributes["steps_attributes"] = @steps.toJSON()
#    attributes["recipe"] = @current_ingridients.toJSON()
    @model.save attributes, {
    wait: true
    success: (response, request) ->
      Backbone.history.navigate('/recipes', {trigger: true, repalce: true})
    error: (response, request) ->
      errorMessage = new RecipeMe.ErrorHandler(response, request)
      if errorMessage.status == 401
      else
        errorMessage.formMessageError($("#recipe_form"))
    }


  createMainObject: (attributes, callback) ->
    step = {steps: @steps, callback: this.createSteps}
    ingridients = {ingridients: @current_ingridients, callback: this.createIngridients}
    @model.createFromForm(attributes, step, ingridients,
      success = (response, request) ->
        Backbone.history.navigate('/recipes', {trigger: true, repalce: true})
      error = (response, request) ->
        errorMessage = new RecipeMe.ErrorHandler(response, request)
        errors = request.responseJSON
        if errorMessage.status == 401
        else
          errorMessage.formMessageError($("#recipe_form"))

      )


  createIngridients: (ingridients, response, request) ->
    @ingridients = ingridients
    @ingridients.each (ingridient) ->
      ingridient.set({recipe_id: response.id})
      if ingridient.get("id") == undefined
        ingridient.url = "api/recipes/#{response.id}/ingridients"
      else
        ingridient.url = "/api/recipes/#{response.id}/ingridients/#{ingridient.get("id")}"
      ingridient.save()


  createSteps: (steps, response, request) ->
    @steps = steps
    @steps.each (step) ->
      step.set({recipe_id: response.id})
      if step.get("id") == undefined
        step.url = "/api/recipes/#{response.id}/steps"
      else
        step.url = "/api/recipes/#{response.id}/steps/#{step.get("id")}"
      step.save()

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
    $("#recipePlaceholder").removeClass("empty entered error")
    $("#recipePlaceholder").next(".error-text").remove()
    this.createRecipeImage(event, "Recipe")
    return false

  addRecipeStep: (event) ->
    event.preventDefault()
    if @model
      @step = new RecipeMe.Models.Step(recipe_id: @model.id)
    else
      @step = new RecipeMe.Models.Step()
    @steps.add(@step)
    this.renderRecipeStep(@step)

  addIngridient: (event) ->
    event.preventDefault()
    @ingridient = new RecipeMe.Models.Ingridient(recipe: @model.get("id"))
    @current_ingridients.add(@ingridient)
    view = new RecipeMe.Views.IngridientForm(model: @ingridient, collection: @common_ingridients)
    $(".ingridients-list").append(view.render().el)


  renderRecipeStep: (step) ->
    view = new RecipeMe.Views.StepForm(model: step)
    $(".steps-list").append(view.render().el)

  renderRecipeIngridient: (ingridient) ->
    view = new RecipeMe.Views.IngridientForm(model: ingridient)
    $(".ingridients-list").append(view.render().el)

  render: ->
    if @model
      $(@el).html(@template(recipe: @model, categories: @categories))
    else
      $(@el).html(@template(categories: @categories))

    @steps.each(@renderRecipeStep)
    @current_ingridients.each(@renderRecipeIngridient)
    this
    $(".recipe-tags").tagsinput()

  fileUploadAccept: (event) ->
    event.preventDefault()
    event.stopPropagation(event)
    image = this.getFileFromEvent(event)
    @reader.readAsDataURL(image)
    $(".image-placeholder").removeClass("empty error")
    $(".image-placeholder").next(".error-text").remove()
    this.createRecipeImage(event, "Recipe")

  getFileFromEvent: (event) ->
    original = event.originalEvent
    if original.dataTransfer
      uploadedFile = original.dataTransfer.files[0]
    else
      uploadedFile = $(event.target)[0].files[0]
    return uploadedFile

  createRecipeImage: (event, type) ->
    formData = new FormData()
    @image = @model.get("image")
    file = this.getFileFromEvent(event)
    formData.append('name', file)
    formData.append('imageable_type', type)
    if @image == undefined
      @image = new RecipeMe.Models.Image()
    else
      @image = new RecipeMe.Models.Image(@image)

    @image.uploadImage(formData)
    @model.set("image", @image)

