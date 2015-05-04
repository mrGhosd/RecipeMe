class RecipeMe.Views.NewsForm extends Backbone.View
  template: JST["news/form"]
  events:
    'change .news-image-uploader': 'loadNewsImage'
    'submit #news-form': 'saveNews'
    'click .image-placeholder': 'triggetImageUpload'
    'dragenter .image-placeholder': 'enterDrag'
    'dragleave .image-placeholder': 'leaveDrag'
    'drop .image-placeholder': 'dropImage'

  initialize: (params) ->
    if params
      @model = params.model
    else
      @model = new RecipeMe.Models.New()
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

  triggetImageUpload: ->
    $(".news-image-uploader").click()

  loadNewsImage: (event) ->
    event.preventDefault()
    event.stopPropagation()
    image = $(event.target)[0].files[0]
    @reader.readAsDataURL(image)
    $(event.target).closest(".col-md-2").find(".image-placeholder").removeClass("empty")
    this.createImage(event, "News")

  enterDrag: (event) ->
    event.preventDefault()
    $(".image-placeholder").addClass("entered")

  leaveDrag: (event) ->
    event.preventDefault()
    $(".image-placeholder").removeClass("entered")

  getFileFromEvent: (event) ->
    original = event.originalEvent
    if original.dataTransfer
      uploadedFile = original.dataTransfer.files[0]
    else
      uploadedFile = $(event.target)[0].files[0]
    return uploadedFile

  dropImage: (event)->
    event.preventDefault()
    event.stopPropagation()
    file = this.getFileFromEvent(event)
    @reader.readAsDataURL(file)
    $(".image-placeholder").removeClass("empty entered")
    this.createImage(event, "News")
    return false


  createImage: (event, type) ->
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

  saveNews: (event) ->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#news-form"))
    @model.save attributes, {
      wait: true
      success: (response, request) ->
        Backbone.history.navigate('/news', {trigger: true, repalce: true})
      error: (response, request) ->
        errors = request.responseJSON
        $.each errors, (key, value)->
          error = new RecipeMe.ErrorHandler(response, request)
          error.showFormErrorMessage($("#news-form"))
          }



  render: ->
    $(@el).html(@template(news: @model))
    this