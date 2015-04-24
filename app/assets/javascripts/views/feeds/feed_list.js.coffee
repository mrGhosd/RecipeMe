class RecipeMe.Views.FeedList extends Backbone.View
  template: JST['feeds/feed_list']

  initialize: (params) ->
    @page = 1
    @followers = new RecipeMe.Collections.Users({usersURL: "api/users/#{RecipeMe.currentUser.get("id")}/followers"})
    @followers.fetch({async: false})
    if params.collection

      @collection = params.collection
      @collection.on('add', @render, this)
      @collection.on('remove', @render, this)
      @listenTo(Backbone, "Feed", @updateFeedData)

  successFeedUpload: (response, request, collection)->
    for model in response
#      collection.add(model)
      feed = new RecipeMe.Models.Feed({id: model.user_id, feed: model.id})
      feed.fetch
        success: (model) ->
          view = new RecipeMe.Views.FeedMain({feed: model})
          $(".feed-list").append(view.render().el)

  updateFeedData: (data) ->
    followersID = @followers.pluck("id")
    console.log data
    if parseInt(data.id, 10) in followersID
      if data.action == "create"
        feed = new RecipeMe.Models.Feed({id: data.id, feed: data.obj.id})
        feed.fetch
          success: (model) ->
            @collection.add(feed)
      if data.action == "destroy"
        feed = new RecipeMe.Models.Feed({id: data.id, feed: data.obj.id})
        @collection.remove(feed)

  addJustUploadedFeed: (model) ->
    feed = new RecipeMe.Models.Feed({id: model.id, feed: model.obj.id})
    feed.fetch
      success: (model) ->
        view = new RecipeMe.Views.FeedMain({feed: model})
        $(".feed-list").prepend(view.render().el)

  render: ->
    $(@el).html(@template())
    @collection.each(@addFeed)
    window.scrollUpload.init(@page, "api/users/#{RecipeMe.currentUser.get('id')}/feeds", $("div.feed-list"), this.successFeedUpload, @collection)
    this

  addFeed: (feed)->
    view = new RecipeMe.Views.FeedMain({feed: feed})
    $(".feed-list").prepend(view.render().el)