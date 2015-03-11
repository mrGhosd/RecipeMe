class RecipeMe.Views.StepForm extends Backbone.View
  template: JST['recipes/step_form']
  className: 'step-block'
  events:
    'change input.step-image': 'uploadRecipeStepImage'
    'click  .step-placeholder': 'triggerFileUpload'
    'dragenter .step-placeholder': 'enterDrag'
    'dragleave .step-placeholder': 'leaveDrag'
    'drop .step-placeholder': 'dropImage'

  initialize: (params, event)->
    @model = params.model if params.model
    this.render()

  initFileReader: (image)->
    @reader = new FileReader()
    @reader.onload = (event) ->
      dataUri = event.target.result
      img = new Image(100, 75)
      img.class = "image-view"
      img.src = dataUri
      image.html(img)
    @reader.onerror = (event) ->
      console.log "ОШИБКА!"

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

  

  triggerFileUpload: (event) ->
    if $(event.target).next("input.step-image").length > 0
      $(event.target).next("input.step-image").click()
    else
      $(event.target).parent().next("input.step-image").click()

  render: ->
    if @model
      $(@el).html(@template(step: @model))
    else
      $(@el).html(@template())
    this