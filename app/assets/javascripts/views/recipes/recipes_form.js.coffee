class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'submit #recipe_form': 'createRecipe'
    'click .back-button': 'returnToList'

  initialize: ->
    this.render()
    console.log @collection
    console.log @type
    $("#recipe_form").fileupload()

  createRecipe:(event) ->
    event.preventDefault()
    formData = new FormData()
    image = $("#recipe_form #image")[0].files[0]
    title = $("#recipe_form #title").val()
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
        @collection.fetch({reset: true})
        @returnToList(jqXHR)

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true})


  render: ->
    $(@el).html(@template())
    this


