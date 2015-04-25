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
    'click .add-ingridient': 'addIngridient'

  initialize: (options = {}) ->
    @form = this
    if options.model
      @model = options.model
      @steps = @model.get('steps')
      @steps.fetch({async: false})
      @current_ingridients = @model.get('ingridients')
      @current_ingridients.fetch({async: false})
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
    $("#recipe_form input, #recipe_form textarea").removeClass("error")
    $(".error-text").remove()
    attributes = window.appHelper.formSerialization($("#recipe_form"))
    @model.set(attributes)
    this.createMainObject(@model.attributes, this.createSteps)


  createMainObject: (attributes, callback) ->
    step = {steps: @steps, callback: this.createSteps}
    ingridients = {ingridients: @current_ingridients, callback: this.createIngridients}
    @model.createFromForm(attributes, step, ingridients,
      success = (response, request) ->
#        RecipeMe.currentUser.fetch()
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
      console.log ingridient
      ingridient.save(
        success: (response, request) ->
          console.log response
          console.log request
        error: (response, request) ->
          console.log response
          console.log request
      )


  createSteps: (steps, response, request) ->
    @steps = steps
    @steps.each (step) ->
      step.set({recipe_id: response.id})
      if step.get("id") == undefined
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
    console.log ingridient.url()
    view = new RecipeMe.Views.IngridientForm(model: ingridient)
    $(".ingridients-list").append(view.render().el)

  render: ->
    console.log @current_ingridients
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
#    $("#recipe_form .recipe-image").val()
#    if $("#recipe_form .recipe-image").val() == "" || typeof $("#recipe_form .recipe-image").val() == "undefined"
#      return false
#    else
#      $(".image-placeholder .image-view").remove()
    image = this.getFileFromEvent(event)
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
    @image = @model.get("image")
    file = this.getFileFromEvent(event)
    formData.append('name', file)
    formData.append('imageable_type', type)
#    if $(".image-placeholder img").attr("image_id") && $(".image-placeholder img").attr("image_id").length > 0
#      image_id = $(".image-placeholder img").attr("image_id")
#      formData.append('imageable_id', image_id)
    if @image == undefined
      @image = new RecipeMe.Models.Image()
    else
      @image = new RecipeMe.Models.Image(@image)

    @image.uploadImage(formData)
    @model.set("image", @image)
    console.log @model

