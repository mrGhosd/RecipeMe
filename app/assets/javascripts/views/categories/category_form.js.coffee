class RecipeMe.Views.CategoryForm extends Backbone.View
  template: JST["categories/form"]

  events:
    'submit #category_form': 'submitCategory'

  initialize: (options = {}) ->
    if options.model
      @model = options.model

    this.render()

  submitCategory: (event) ->
    event.preventDefault()
    console.log @model
    attributes = window.appHelper.formSerialization($("#category_form"))
    @model.save(attributes,
      success: (response, request) ->
        Backbone.history.navigate('/categories', {trigger: true, repalce: true})
      error: (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#category_form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#category_form input[name=\"#{key}\"]"))
        )
    )

  render: ->
    $(@el).html(@template(category: @model))
    this