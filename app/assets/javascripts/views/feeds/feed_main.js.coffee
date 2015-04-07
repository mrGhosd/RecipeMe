class RecipeMe.Views.FeedMain extends Backbone.View
  template: JST["feeds/feed_main"]
  className: "feed-item"

  initialize: (params) ->
    if params.feed
      @feed = params.feed
      @user = new RecipeMe.Models.User({id: @feed.get("user_id")})
      @user.fetch({async: false})

  render: ->
    render: ->
    $(@el).html(@template({feed: @feed, user: @user}))
    this