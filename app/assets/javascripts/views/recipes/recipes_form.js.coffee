class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'click .recipe-image': 'resetFile'
    'change .recipe-image': 'fileUploadAccept'
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'

  initialize: (options = {}) ->
    @model = options['model'] if options['model']
    this.render()
    @reader = new FileReader()
    @fileUploadAccept()

  createRecipe:(event) ->
    event.preventDefault()
    $("#recipe_form input, #recipe_form textarea").removeClass("error")
    $(".error-text").remove()
    attributes = window.appHelper.formSerialization($("#recipe_form"))
    if @model

    else
      @model = new RecipeMe.Models.Recipe()

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


  render: ->
    if @model
      $(@el).html(@template(recipe: @model))
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



  updateRecipesCollection: ->
    RecipeMe.recipesCollection.fetch()
