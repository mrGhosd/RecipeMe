class RecipeMe.Views.StepForm extends Backbone.View
  template: JST['recipes/step_form']
  className: 'step-block'
  events:
    'change input.step-image': 'uploadRecipeStepImage'
    'click  .step-placeholder': 'triggerFileUpload'
    'dragenter .step-placeholder': 'enterDrag'
    'dragleave .step-placeholder': 'leaveDrag'
    'drop .step-placeholder': 'dropImage'
    'focusout .step-description': 'updateDescription'

  initialize: (params, event)->
    @model = params.model
    @reader = new FileReader()
    this.render()

  initFileReader: (image)->
    @reader.onload = (event) ->
      dataUri = event.target.result
      img = new Image(100, 75)
      img.class = "image-view"
      img.src = dataUri
      image.html(img)
    @reader.onerror = (event) ->
      console.log "ОШИБКА!"

  updateDescription: (event) ->
    text = $(event.target).val()
    @model.set({description: text})

  uploadRecipeStepImage: (event) ->
    this.initFileReader($(event.target).prev(".step-placeholder"))
    $(event.target).val()
    if $(event.target).val() == "" || typeof $(event.target).val() == undefined
      return false
    else
      $(event.target).prev(".step-placeholder img").remove()
      image = $(event.target)[0].files[0]
      @reader.readAsDataURL(image)
      $(event.target).prev(".step-placeholder").removeClass("empty")
      this.createStepImage(event, "Step")

  enterDrag: (event) ->
    $(event.target).addClass("hover")

  leaveDrag: (event) ->
    $(event.target).removeClass("hover")

  dropImage: (event) ->
    event.preventDefault()
    event.stopPropagation()
    this.initFileReader($(event.target))
    file = this.getFileFromEvent(event)
    @reader.readAsDataURL(file)
    $(event.target).removeClass("empty hover")
    this.createStepImage(event, "Step")
    return false

  getFileFromEvent: (event) ->
    original = event.originalEvent
    if original.dataTransfer
      uploadedFile = original.dataTransfer.files[0]
    else
      uploadedFile = $(event.target)[0].files[0]
    return uploadedFile

  triggerFileUpload: (event) ->
    if $(event.target).next("input.step-image").length > 0
      $(event.target).next("input.step-image").click()
    else
      $(event.target).parent().next("input.step-image").click()

  createStepImage: (event, type) ->
    formData = new FormData()
    @image = @model.get("image")
    file = this.getFileFromEvent(event)
    formData.append('name', file)
    formData.append('imageable_type', type)
    console.log @image
    if $(event.target).closest(".step-block").attr("image_id") && $(event.target).closest(".step-block").attr("image_id").length > 0
      image_id = $(event.target).closest(".step-block").attr("image_id")
      formData.append('imageable_id', image_id)
    if @image == null
      @image = new RecipeMe.Models.Image()
    console.log @image
    @image.uploadImage(formData)
    @model.set("image", @image)


  render: ->
    if @model
      $(@el).html(@template(step: @model))
    else
      $(@el).html(@template())
    this