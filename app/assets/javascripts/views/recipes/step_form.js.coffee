class RecipeMe.Views.StepForm extends Backbone.View
  template: JST['recipes/step_form']
  className: 'step-block'
  events:
    'change input.step-image-uploader': 'uploadRecipeStepImage'
    'click  .step-placeholder': 'triggerFileUpload'
    'dragenter .step-placeholder': 'enterDrag'
    'dragleave .step-placeholder': 'leaveDrag'
    'drop .step-placeholder': 'dropImage'
    'focusout .step-description': 'updateDescription'
    'click .remove-step': 'removeStep'

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
      if image.find("img") == undefined
        image.find(".step-placeholder").html(img)
      else
        image.parent().html(img)
    @reader.onerror = (event) ->
      console.log "ОШИБКА!"

  updateDescription: (event) ->
    text = $(event.target).val()
    @model.set({description: text})

  uploadRecipeStepImage: (event) ->
    event.preventDefault()
    event.stopPropagation(event)
    this.initFileReader($(event.currentTarget).closest('.step-image').find(".step-placeholder"))
#    $(event.target).val()
#    if $(event.target).val() == "" || typeof $(event.target).val() == undefined
#      return false
#    else
#      $(event.target).prev(".step-placeholder img").remove()
    image = $(event.target)[0].files[0]
    @reader.readAsDataURL(image)
    $(event.currentTarget).closest('.step-image').find(".step-placeholder").removeClass("empty")
    this.createStepImage(event, "Step")

  enterDrag: (event) ->
    $(event.target).addClass("hover")

  leaveDrag: (event) ->
    $(event.target).removeClass("hover")

  removeStep: (event) ->
    if @model.isNew()
      @model.collection.remove(@model)
    else
      @model.url = "/api/recipes/#{@model.get("recipe_id")}/steps/#{@model.get("id")}"
      @model.destroy()
    $(event.target).closest(".step-block").fadeOut()



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
    $(event.currentTarget).closest(".step-image").find('.step-image-uploader').click()

  createStepImage: (event, type) ->
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


  render: ->
    if @model
      $(@el).html(@template(step: @model))
    else
      $(@el).html(@template())
    this