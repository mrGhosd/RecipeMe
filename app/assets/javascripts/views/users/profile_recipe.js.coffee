class RecipeMe.Views.ProfileRecipe extends Backbone.View

  template: JST['users/recipe_user']
  tagName: 'div'
  className: 'profile-recipe'
  tagClass: 'col-md-4'

  initialize:(params) ->
    @params = params
    this.render()

  render: ->
    $(@el).html(@template(recipe: @params.model))
    this