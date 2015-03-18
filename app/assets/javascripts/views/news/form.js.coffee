class RecipeMe.Views.NewsForm extends Backbone.View
  template: JST["news/form"]
  events:
    'submit #news-form': 'saveNews'

  initialize: (params) ->
    if params
      @model = params.model
    else
      @model = new RecipeMe.Models.New()

  saveNews: (event) ->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#news-form"))
    @model.save(attributes,
      success: (response, request) ->
        Backbone.history.navigate('/news', {trigger: true, repalce: true})
      error: (response, request) ->
        errors = request.responseJSON
        $.each(errors, (key, value)->
          $("#news-form input[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#news-form input[name=\"#{key}\"]"))
        )
    )

  render: ->
    $(@el).html(@template(news: @model))
    this