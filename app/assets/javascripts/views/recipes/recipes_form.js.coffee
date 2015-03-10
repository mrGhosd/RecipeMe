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
    if options['model']
      @model = options['model']
      @steps = @model.get('steps')

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
    @model = new RecipeMe.Models.Recipe() if !@model
    @model.save(attributes,
      success: (response, request)->
        RecipeMe.currentUser.fetch()
        Backbone.history.navigate('/recipes', {trigger: true, repalce: true})
      error: (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#recipe_form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#recipe_form input[name=\"#{key}\"]"))
        )
    )
    @updateRecipesCollection()

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

  addRecipeStep: (event)->
    event.preventDefault()
    view = new RecipeMe.Views.RecipeStep()
    $(".steps-group").append(view.render().el)

  removeStep: (event)->
    console.log $(event.target).closest(".step-block").remove()

  render: ->
    if @model
      $(@el).html(@template(recipe: @model, steps: @steps))
      this
    else
      $(@el).html(@template())
      this
    $(".markItUp").markItUp(window.myHtmlSettings)

  fileUploadAccept: ->
    $("#recipe_form .recipe-image").val()
    if $("#recipe_form .recipe-image").val() == "" || typeof $("#recipe_form .recipe-image").val() == "undefined"
      return false
    else
      $(".image-placeholder .image-view").remove()
      image = $("#recipe_form .recipe-image")[0].files[0]
      @reader.readAsDataURL(image)
      $(".image-placeholder").removeClass("empty")

  updateRecipesCollection: ->
    RecipeMe.recipesCollection.fetch()


  getFileFromEvent: (event) ->
    original = event.originalEvent
    original.dataTransfer.dropEffect = 'copy';
    uploadedFile = original.dataTransfer.files[0]
    return uploadedFile

  createRecipeImage: (event, type) ->
    formData = new FormData()
    file = this.getFileFromEvent(event)
    formData.append('name', file)
    formData.append('imageable_type', type)
    request = new XMLHttpRequest();
    request.open("POST", "/api/images");
    request.send(formData);
    request.onreadystatechange= ->
      if (request.readyState==4 && request.status==200)
        console.log JSON.parse(request.response)
        response = JSON.parse(request.response)
        $(".hidden-image-value-recipe").val(response.id)
