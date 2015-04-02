class RecipeMe.Views.UsersList extends Backbone.View
  template: JST["users/users_list"]
  className: "users-list"

  initialize: (params) ->
    if params
      @collection = params.collection
      @user = params.user


  render: ->
    $(@el).html(@template({user: @user}))
    @collection.each(@addUser)
    this

  addUser: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 150})
    $(".main-users-list").prepend(view.render().el)