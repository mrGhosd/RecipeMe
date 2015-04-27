class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']
  events:
    'click a': 'hideNavigationMenu'
    'click .news-feed': 'resetFeedsCounter'

  initialize:(options = {}) ->
    @listenTo(Backbone, "Auth", @updateView)
    @feed_update = 0
    @view = options.view if options.view
    if RecipeMe.currentUser
      this.setUserMainData()
      @listenTo(Backbone, "User", @updateUser)
      @listenTo(Backbone, "Feed", @updateFeedData)
    this.render()

  updateUser: (data) ->
    if parseInt(@user.get("id"), 10) == parseInt(data.id, 10)
      if data.action == "follow"
        this.updateFollowersList(data.obj)
      if data.action == "following"
        this.updateFollowingList(data.obj)
      if data.action == "unfollowing"
        this.updateUnfollowingList(data.obj)
      if data.action == "unfollow"
        this.updateUnfollowList(data.obj)

  updateFeedData: (data) ->
    followersID = @user.get("followers_list").pluck("id")
    if parseInt(data.id, 10) in followersID
      @feed_update++
      this.addNotificationToUpdate()

  updateView: (data) ->
    this.setUserMainData()
    this.render()


  addNotificationToUpdate: ->
    if $(".feed-notification").length == 0
      feed_item = $("<span class='label label-danger feed-notification'></span>")
      $(".news-feed").append(feed_item)
    $(".feed-notification").text(@feed_update)


  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  removeFollowingMessage: ->
    @user.fetch({async: false})
    @following = new RecipeMe.Collections.Users(RecipeMe.currentUser.get("following_list").first(6))
    this.updateFolowersFollowingList()

  resetFeedsCounter: ->
    @feed_update = 0
    $(".feed-notification").remove()


  updateFolowersFollowingList: (object) ->
    $(".following-block .following-list").html("")
    $(".following-block").find(".following-count").text(@following.length)
    @following.each(@addFollowing)

  updateFollowingList: (data) ->
    current_count = parseInt($(".following-block").find(".following-count").text(), 10)
    @following.pop() if @followers.length == 6
    @following.add(data)
    $(".following-block").find(".following-count").text("#{current_count + 1}")

  updateUnfollowingList: (data) ->
    current_count = parseInt($(".following-block").find(".following-count").text(), 10)
    @following.remove(data)
    $(".following-block").find(".following-count").text("#{current_count - 1}")

  updateFollowersList: (data)->
    current_count = parseInt($(".followers-block").find(".followers-count").text(), 10)
    @followers.pop() if @followers.length == 6
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

  setUserMainData: ->
    if RecipeMe.currentUser
      @user = RecipeMe.currentUser
      @user.url = "api/users/#{@user.get("id")}"
      @user.fetch({async: false})
      console.log @user
      @following = new RecipeMe.Collections.Users(@user.get("following_list").first(6))
      @followers = new RecipeMe.Collections.Users(@user.get("followers_list").first(6))
      @followers.on('add', @render, this)
      @followers.on('remove', @render, this)
      @following.on('add', @render, this)
      @following.on('remove', @render, this)

  addFollower: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 70})
    $(".followers-block .followers-list").prepend(view.render().el)

  addFollowing: (user) ->
    view = new RecipeMe.Views.UserListItem({model: user, size: 70})
    $(".following-block .following-list").prepend(view.render().el)




