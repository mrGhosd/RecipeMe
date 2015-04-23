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
      @followers.on('add', @render, this)
      @followers.on('remove', @render, this)
      @following.on('add', @render, this)
      @listenTo(Backbone, "User", @updateUser)
    @listenTo(Backbone, "navigationMenu", @removeFollowingMessage)
    this.render()

  updateUser: (data) ->
    if parseInt(@user.get("id"), 10) == parseInt(data.id, 10)
      if data.action == "follow"
        this.updateFollowersList(data.obj)
      if data.action == "unfollow"
        this.updateUnfollowList(data.obj)



  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  removeFollowingMessage: ->
    @user.fetch({async: false})
    @following = new RecipeMe.Collections.Users(RecipeMe.currentUser.get("following_list").first(6))
    this.updateFolowersFollowingList()


  updateFolowersFollowingList: (object) ->
    $(".following-block .following-list").html("")
    $(".following-block").find(".following-count").text(@following.length)
    @following.each(@addFollowing)

  updateFollowersList: (data)->
    current_count = parseInt($(".followers-block").find(".followers-count").text(), 10)
    @followers.pop()
    @followers.add(data)
    $(".followers-block").find(".followers-count").text("#{current_count + 1}")

  updateUnfollowList: (data) ->
    current_count = parseInt($(".followers-block").find(".followers-count").text(), 10)
    @followers.remove(data)
    $(".followers-block").find(".followers-count").text("#{current_count - 1}")

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




