class RecipeMe.Views.LikedView extends Backbone.View
  template: JST["users/liked_view"]

  initialize: (params) ->
    if params.user
      @model = params.user

    this.render()

  render: ->
    $(@el).html(@template({user: @model}))
    this

