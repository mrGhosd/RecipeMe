class RecipeMe.Views.LikedView extends Backbone.View
  template: JST["users/liked_view"]

  initialize: (params) ->
    if params.user
      @model = params.user
      console.log @model

    this.render()

  render: ->
    $(@el).html(@template({user: @model}))
    this

