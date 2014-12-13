class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'click .recipe-image': 'resetFile'
    'change .recipe-image': 'fileUploadAccept'
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'

  initialize: (options = {}) ->
    @model = options['model'] if options['model']
    @type = options['type']
    this.render()
    @reader = new FileReader()
    @fileUploadAccept()

  createRecipe:(event) ->
    url
    if @type == "POST"
      url = "/api/recipes"
    else
      url = "/api/recipes/#{@model.get('id')}"

    event.preventDefault()
    formData = new FormData()
    title = $("#recipe_form .recipe-title").val()
    formData.append('title', title)
    if $("#recipe_form .recipe-image")[0].files[0]
      image = $("#recipe_form .recipe-image")[0].files[0]
      formData.append('image', image)

    $.ajax url,
      type: @type
      data:  formData
      cache: false
      contentType: false
      processData: false
      dataType: 'json'
      success: (data, textStatus, jqXHR) =>
        @model.fetch() if @model
        @returnToList(jqXHR)

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true, repalce: true})


  render: ->
    if @model
      $(@el).html(@template(recipe: @model))
      this
    if @collection
      $(@el).html(@template())
      this

  fileUploadAccept: ->
    $("#recipe_form .recipe-image").val()
    if $("#recipe_form .recipe-image").val() == "" || typeof $("#recipe_form .recipe-image").val() == "undefined"
      return false
    else
      $(".image-placeholder .image-view").remove()
      @reader.onload = (event) ->
        dataUri = event.target.result
        img = new Image(200, 200)
        img.class = "image-view"
        img.src = dataUri
        $(".image-placeholder").html(img)
      @reader.onerror = (event) ->
        console.log "ОШИБКА!"
      image = $("#recipe_form .recipe-image")[0].files[0]
      @reader.readAsDataURL(image)

