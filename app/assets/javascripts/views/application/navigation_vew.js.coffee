class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']
  events:
    'click a': 'hideNavigationMenu'

  initialize:(options = {}) ->
    @view = options.view if options.view
    if RecipeMe.currentUser
      @user = RecipeMe.currentUser
      @user.fetch({async: false})
      @following = new RecipeMe.Collections.Users(RecipeMe.currentUser.get("following_list").first(6))
      @followers = new RecipeMe.Collections.Users(RecipeMe.currentUser.get("followers_list").first(6))
    @listenTo(Backbone, "navigationMenu", @removeFollowingMessage)
    this.render()

  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  removeFollowingMessage: ->
    @user.fetch({async: false})
    @following = new RecipeMe.Collections.Users(RecipeMe.currentUser.get("following_list").first(6))
    this.updateFolowersFollowingList()


  updateFolowersFollowingList: ->
    $(".following-block .following-list").html("")
    $(".following-block").find(".following-count").text(@following.length)
    @following.each(@addFollowing)

  render: ->
    $(@el).html(@template(user: @user))
    if RecipeMe.currentUser
      @followers.each(@addFollower)
      @following.each(@addFollowing)
    this



  addFollower: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 70})
    $(".followers-block .followers-list").prepend(view.render().el)

  addFollowing: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 70})
    $(".following-block .following-list").prepend(view.render().el)




