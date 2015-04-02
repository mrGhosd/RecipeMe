class RecipeMe.Views.UsersList extends Backbone.View
  template: JST["users/users_list"]
  className: "users-list"

  initialize: (params) ->
    if params.collection
      @collection = params.collection


  render: ->
    $(@el).html(@template())
    @collection.each(@addUser)
    this

  addUser: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 150})
    $(".main-users-list").prepend(view.render().el)