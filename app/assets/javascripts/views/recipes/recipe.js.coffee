class RecipeMe.Views.Recipe extends Backbone.View

  template: JST['recipes/recipe']
  tagName: 'li'
  className: 'recipe-field'
  tagClass: 'col-md-4'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(recipe: @model))
    this