class RecipeMe.Views.CategoryShow extends Backbone.View
  template: JST["categories/show"]
  className: "category-view"

  initialize: (params = {})->
    @model = params.model if params.model
    this.render()

  render: ->
    $(@el).html(@template(category: @model))
    this