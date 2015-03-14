class RecipeMe.Views.Category extends Backbone.View
  template: JST['categories/category']
  className: 'category-item'

  events:
    'click .destroy-category': 'destoryCategory'

  initialize: (params = {})->
    @model = params.model if params.model
    this.render()

  destoryCategory: (event) ->
    event.preventDefault()
    @model.destroy
    $(event.target).closest(".category-item").fadeOut('slow').remove()

  render: ->
    $(@el).html(@template(category: @model))
    this