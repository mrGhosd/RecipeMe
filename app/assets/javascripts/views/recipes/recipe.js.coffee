class RecipeMe.Views.Recipe extends Backbone.View

  template: JST['recipes/recipe']
  tagName: 'li'
  className: 'recipe-field'
  tagClass: 'col-md-4'
  events:
    'click .destroy-recipe':'recipeDestroy'

  initialize: ->

    this.render()



  render: ->
    $(@el).html(@template(recipe: @model))
    this


  recipeDestroy: (event) ->
    @model.destroy
      success: ->
        $(event.target).closest("li").fadeOut('slow')