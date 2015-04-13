class RecipeMe.Views.ProfileComment extends Backbone.View
  template: JST["users/profile_comment"]
  className: "user-comment-item"

  initialize: (params) ->
    if params
      @comment = params.model
      @recipe = params.model.recipe

  render: ->
    $(@el).html(@template(comment: @comment, recipe: @recipe))
    this

