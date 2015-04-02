class RecipeMe.Views.UserListItem extends Backbone.View
  template: JST["users/user_list_item"]
  className: "user-list-item"

  initialize: (params) ->
    if params
      @model = params.model
      @size = params.size

  render: ->
    $(@el).html(@template(user: @model, size: @size))
    this