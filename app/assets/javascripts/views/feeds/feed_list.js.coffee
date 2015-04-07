class RecipeMe.Views.FeedList extends Backbone.View
  template: JST['feeds/feed_list']

  initialize: (params) ->
    if params.collection
      @collection = params.collection

  render: ->
    $(@el).html(@template())
    @collection.each(@addFeed)
    this

  addFeed: (feed)->
    view = new RecipeMe.Views.FeedMain({feed: feed})
    $(".feed-list").prepend(view.render().el)