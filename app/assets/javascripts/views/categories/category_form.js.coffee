class RecipeMe.Views.CategoryForm extends Backbone.View
  template: JST["categories/form"]

  events:
    'change .category_image': 'uploadCategoryImage'
    'submit #category_form': 'submitCategory'
    'click .back-button': 'returnToList'
    'click .image-placeholder': 'triggerCategoryImageInput'
    'dragenter .image-placeholder': 'enterDrag'
    'dragleave .image-placeholder': 'leaveDrag'
    'drop .image-placeholder': 'dropImage'


  initialize: (options = {}) ->
    if options.model
      @model = options.model
    this.render()
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

  uploadCategoryImage: (event) ->
    event.preventDefault()
    event.stopPropagation()
    image = $(event.target)[0].files[0]
    @reader.readAsDataURL(image)
    $(event.target).closest(".form-group").find(".image-placeholder").removeClass("empty")
    this.createCategoryImage(event, "Category")

  triggerCategoryImageInput: (event) ->
    $(".category_image").click()

  getFileFromEvent: (event) ->
    original = event.originalEvent
    if original.dataTransfer
      uploadedFile = original.dataTransfer.files[0]
    else
      uploadedFile = $(event.target)[0].files[0]
    return uploadedFile

  enterDrag: (event) ->
    event.preventDefault()
    $(event.target).addClass("entered")

  leaveDrag: (event) ->
    event.preventDefault()
    $(event.target).removeClass("entered")

  dropImage: (event) ->
    event.preventDefault()
    event.stopPropagation()
    file = this.getFileFromEvent(event)
    @reader.readAsDataURL(file)
    $(event.target).removeClass("empty hover")
    this.createCategoryImage(event, "Category")
    return false

  createCategoryImage: (event, type) ->
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

  submitCategory: (event) ->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#category_form"))
    @model.save attributes,
      wait: true,
      success: (response, request) ->
        Backbone.history.navigate('/categories', {trigger: true, replace: true})
      error: (response, request) ->
        error = new RecipeMe.ErrorHandler(response, request)
        error.showFormErrorMessage($("#category_form"))


  returnToList: (event) ->
    Backbone.history.navigate('/categories', {trigger: true, repalce: true})

  render: ->
    $(@el).html(@template(category: @model))
    this