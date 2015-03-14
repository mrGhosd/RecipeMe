class RecipeMe.Views.Category extends Backbone.View
  template: JST['categories/category']
  className: 'category-item'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(category: @model))
    this