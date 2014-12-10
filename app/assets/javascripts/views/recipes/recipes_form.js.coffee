class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'click .recipe-image': 'resetFile'
    'change .recipe-image': 'fileUploadAccept'
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'

  initialize: ->
    this.render()
    @reader = new FileReader()
    @fileUploadAccept()

  createRecipe:(event) ->
    event.preventDefault()
    formData = new FormData()
    image = $("#recipe_form .recipe-image")[0].files[0]
    title = $("#recipe_form .recipe-title").val()
    formData.append('title', title)
    formData.append('image', image)

    $.ajax "/api/recipes",
      type: "POST"
      data:  formData
      cache: false
      contentType: false
      processData: false
      dataType: 'json'
      success: (data, textStatus, jqXHR) =>
        @returnToList(jqXHR)

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true})


  render: ->
    $(@el).html(@template(recipe: @model))
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

