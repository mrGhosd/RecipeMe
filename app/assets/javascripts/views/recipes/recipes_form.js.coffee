class RecipeMe.Views.RecipesForm extends Backbone.View
  template: JST['recipes/form']

  params:
    title: $(".recipe_title").val()
    image: $(".recipe_image").val()

  initialize: ->
    this.render()
    $("#recipe_form").fileupload()
    $(document).delegate("#recipe_form", "submit", @createRecipe)

  render: ->
    $(@el).html(@template())
    this

  createRecipe:(event) ->
    event.preventDefault()
    formData = new FormData()
    image = $("#recipe_form #image")[0].files[0]
    title = $("#recipe_form #title").val()
    formData.append('title', title)
    formData.append('image', image)
    $.ajax
      type: "POST"
      url: "/api/recipes"
      data:  formData
      cache: false
      contentType: false
      processData: false
      success: ->
        alert("horray!")