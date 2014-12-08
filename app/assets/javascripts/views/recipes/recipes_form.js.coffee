class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  events:
    'submit #recipe_form': 'createRecipe'

  initialize: ->
    this.render()
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
        console.log "SUCCESS AJAX"
        console.log @collection.fetch({reset: true})
      complete: =>

  updateRecipesList: (data) =>
    console.log @collection
    console.log data



  render: ->
    $(@el).html(@template())
    this


