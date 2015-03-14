class RecipeMe.Views.CategoryForm extends Backbone.View

  template: JST["categories/form"]

  initialize: (options = {}) ->
    if options.model
      @model = options.model

    this.render()

  render: ->
    $(@el).html(@template(category: @model))
    this