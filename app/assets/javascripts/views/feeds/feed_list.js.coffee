class RecipeMe.Views.FeedList extends Backbone.View
  template: JST['feeds/feed_list']

  initialize: (params) ->
    @page = 1
    if params.collection
      @collection = params.collection
      @collection.on('add', @render, this)

  successFeedUpload: (response, request, collection)->
    for model in response
#      collection.add(model)
      feed = new RecipeMe.Models.Feed({id: model.user_id, feed: model.id})
      feed.fetch
        success: (model) ->
          view = new RecipeMe.Views.FeedMain({feed: model})
          $(".feed-list").append(view.render().el)

  addFeedAfterUpload: (feed) ->


  render: ->
    $(@el).html(@template())
    @collection.each(@addFeed)
    window.scrollUpload.init(@page, "api/users/#{RecipeMe.currentUser.get('id')}/feeds", $("div.feed-list"), this.successFeedUpload, @collection)
    this

  addFeed: (feed)->
    view = new RecipeMe.Views.FeedMain({feed: feed})
    $(".feed-list").prepend(view.render().el)